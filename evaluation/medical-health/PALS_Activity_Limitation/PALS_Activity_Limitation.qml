qmlVersion: '2.7'
questionnaire:
  title: Participation and Activity Limitation Survey – 2001 (Children – under 15), Form 03
  blocks:
  - id: b_s1_preamble
    title: Interview setup
    items:
    - id: BORN_AFTER_19960515
      kind: Question
      title: External input derived from the cover page date of birth (DOB), used by the interviewer instruction 'If child was born AFTER May 15, 1996'
      external: true
      input:
        control: Radio
        labels:
          1: Born AFTER May 15, 1996
          2: Born on or before May 15, 1996
  - id: b_s1_cover
    title: FORM 03 – INFORMATION SOURCE (cover page)
    items:
    - id: FIRST_NAME
      kind: Question
      title: First name(s) [child; cover page field, printed without an id]
      input:
        control: Textarea
    - id: INITIALS
      kind: Question
      title: Initial(s) [cover page field, printed without an id]
      input:
        control: Textarea
    - id: FAMILY_NAME
      kind: Question
      title: Family name [child; cover page field, printed without an id]
      input:
        control: Textarea
    - id: ADDRESS
      kind: Question
      title: 'Address: Number and Street or lot and concession or exact location [cover page field, printed without an id]'
      input:
        control: Textarea
    - id: APT_NO
      kind: Question
      title: Apt. No. [cover page field, printed without an id]
      input:
        control: Textarea
    - id: CITY
      kind: Question
      title: City, Town, Village or Municipality [cover page field, printed without an id]
      input:
        control: Textarea
    - id: PROVINCE
      kind: Question
      title: Province or Territory [cover page field, printed without an id]
      input:
        control: Textarea
    - id: POSTAL_CODE
      kind: Question
      title: Postal Code [cover page field, printed without an id]
      input:
        control: Textarea
    - id: TELEPHONE
      kind: Question
      title: 'Telephone: Area code, Telephone No. [cover page field, printed without an id]'
      input:
        control: Textarea
    - id: SEX
      kind: Question
      title: 'Sex: Male / Female [cover page field, printed without an id; the source prints no codes, 1 and 2 follow printed order]'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: DOB
      kind: Question
      title: 'Date of birth: Year Month Day [cover page field, printed without an id]'
      input:
        control: Textarea
    - id: RESIDENTS_ADULTS
      kind: Question
      title: 'Number of residents in the household: Adults (15 and over) [cover page field, printed without an id]'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: RESIDENTS_CHILDREN
      kind: Question
      title: 'Number of residents in the household: Children (0-14) [cover page field, printed without an id]'
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s1_respondent
    title: Respondent and proxy status
    items:
    - id: PROXY_NAME
      kind: Question
      title: 'Name of parent/guardian or proxy: First name(s), Family name [cover page field, printed without an id]'
      input:
        control: Textarea
    - id: PROXY_REASON
      kind: Question
      title: 'Reason for proxy: (1) Parent/Guardian does not speak English or French; (2) Parent/Guardian unable to respond; (3) Parent/Guardian absent – duration of survey [printed without an id]'
      input:
        control: Radio
        labels:
          1: (1) Parent/Guardian does not speak English or French
          2: (2) Parent/Guardian unable to respond
          3: (3) Parent/Guardian absent – duration of survey
    - id: INFO_SOURCE
      kind: Question
      title: 'Non-Proxy: (1) Parent/Guardian; (2) Parent/Guardian (via interpreter). Proxy: (3) Other household member; (4) Other, specify [printed without an id; one code list 1-4 covering Non-Proxy and Proxy]'
      input:
        control: Radio
        labels:
          1: '(1) Non-Proxy: Parent/Guardian'
          2: '(2) Non-Proxy: Parent/Guardian (via interpreter)'
          3: '(3) Proxy: Other household member'
          4: '(4) Proxy: Other, specify'
  - id: b_s2_filter
    title: SECTION A — FILTER QUESTIONS
    items:
    - id: A1
      kind: Question
      title: 'Does ..... have any DIFFICULTY hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: A2A
      kind: Question
      title: 'Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at home? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: A2B
      kind: Question
      title: 'Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at work or at school? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often
          3: (3) No
          5: (5) Not applicable
          98: (x) Don’t know
          99: (r) Refusal
    - id: A2C
      kind: Question
      title: 'Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do in other activities, for example, transportation or leisure? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_hearing_aid
    title: Hearing aid use
    items:
    - id: B1
      kind: Question
      title: I’m going to ask you about .....’s ability to do certain activities. Please tell me only about those difficulties that have lasted, or are expected to last six months or more. Does ..... use a hearing aid or hearing aids?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_hearing_with_aid
    title: Hearing with hearing aid
    precondition:
    - predicate: not (B1.outcome in [3, 98])
      hint: Asked only when question B1 is none of "(3) No", "(x) Don’t know".
    items:
    - id: B2
      kind: Question
      title: 'WITH HEARING AID(S), how would you describe his/her ability to hear? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Child has no problem hearing
          2: (2) Child has difficulty hearing
          98: (x) Don’t know
          99: (r) Refusal
    - id: B3
      kind: Question
      title: 'How much difficulty? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (B2.outcome == 1)
        hint: Asked only when question B2 is not "(1) Child has no problem hearing".
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_hearing_unaided
    title: Hearing ability
    precondition:
    - predicate: not (B2.outcome == 1)
      hint: Asked only when question B2 is not "(1) Child has no problem hearing".
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    items:
    - id: B4
      kind: Question
      title: 'How would you describe .....’s ability to hear? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Child has no problem hearing
          2: (2) Child has difficulty hearing
          3: (3) Child cannot hear
          98: (x) Don’t know
          99: (r) Refusal
    - id: B5
      kind: Question
      title: 'How much difficulty? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (B4.outcome == 1)
        hint: Asked only when question B4 is not "(1) Child has no problem hearing".
      - predicate: not (B4.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
        hint: Not asked when the child cannot hear.
      - predicate: not (B4.outcome == 3 and BORN_AFTER_19960515.outcome == 2)
        hint: Not asked when the child cannot hear.
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_hearing_use
    title: Hearing aids used
    precondition:
    - predicate: not (B2.outcome == 1)
      hint: Asked only when question B2 is not "(1) Child has no problem hearing".
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B4.outcome == 1)
      hint: Asked only when question B4 is not "(1) Child has no problem hearing".
    - predicate: not (B4.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot hear.
    items:
    - id: B6
      kind: Question
      title: Does .... USE any aids, specialized equipment or services for children with hearing difficulties, for example, a volume control telephone or T.V. decoder?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_hearing_now
    title: Hearing aids now used
    precondition:
    - predicate: not (B2.outcome == 1)
      hint: Asked only when question B2 is not "(1) Child has no problem hearing".
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B4.outcome == 1)
      hint: Asked only when question B4 is not "(1) Child has no problem hearing".
    - predicate: not (B4.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot hear.
    - predicate: not (B6.outcome in [3, 98])
      hint: Asked only when question B6 is none of "(3) No", "(x) Don’t know".
    items:
    - id: B7_a
      kind: Question
      title: 'Does he/she now use: (a) a volume control telephone Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_b
      kind: Question
      title: 'Does he/she now use: (b) a closed caption TV or decoder'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_c
      kind: Question
      title: 'Does he/she now use: (c) a TTY or TDD'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_d
      kind: Question
      title: 'Does he/she now use: (d) an amplifier, such as FM or infrared'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_e
      kind: Question
      title: 'Does he/she now use: (e) a computer to communicate (e.g.e-mail or chat service)'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_f
      kind: Question
      title: 'Does he/she now use: (f) a Sign language interpreter'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B7_g
      kind: Question
      title: 'Does he/she now use: (g) other aid, specify'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p1_hearing_need
    title: Hearing aids needed and communication
    precondition:
    - predicate: not (B2.outcome == 1)
      hint: Asked only when question B2 is not "(1) Child has no problem hearing".
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B4.outcome == 1)
      hint: Asked only when question B4 is not "(1) Child has no problem hearing".
    - predicate: not (B4.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot hear.
    items:
    - id: B8
      kind: Question
      title: Are there any aids or services for children with hearing difficulties that ..... CURRENTLY needs, but does not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: B9
      kind: Question
      title: 'Which aids or services does he/she NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) A hearing aid or hearing aids
          2: (b) A volume control telephone
          4: (c) A closed caption T.V. or decoder
          8: (d) A TTY or TDD
          16: (e) An amplifier, such as FM or infrared
          32: (f) A computer to communicate (e.g. e-mail or chat service)
          64: (g) A Sign language interpreter
          128: (h) Other aid, specify
          256: (x) Don’t know
          512: (r) Refusal
    - id: B10_a
      kind: Question
      title: 'This question deals with certain communication skills. Does ..... : (a) use Sign Language, such as ASL or LSQ? Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B10_b
      kind: Question
      title: 'This question deals with certain communication skills. Does ..... : (b) speech read or lip read?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p1_vision_glasses
    title: Glasses or contact lenses
    items:
    - id: B11
      kind: Question
      title: Does ..... wear glasses or contact lenses to see up close or at a distance?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_vision_with
    title: Vision with glasses or contact lenses
    precondition:
    - predicate: not (B11.outcome in [3, 98])
      hint: Asked only when question B11 is none of "(3) No", "(x) Don’t know".
    items:
    - id: B12
      kind: Question
      title: 'With GLASSES or CONTACT LENSES, how would you describe his/her vision ability? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Child has no problem seeing
          2: (2) Child has difficulty seeing
          98: (x) Don’t know
          99: (r) Refusal
    - id: B13
      kind: Question
      title: 'How much difficulty? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
        hint: Not asked when the child has no problem seeing.
      - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
        hint: Not asked when the child has no problem seeing.
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_vision_unaided
    title: Vision ability
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    items:
    - id: B14
      kind: Question
      title: 'How would you describe .....’s vision ability? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Child has no problem seeing
          2: (2) Child has difficulty seeing
          3: (3) Child cannot see
          98: (x) Don’t know
          99: (r) Refusal
    - id: B15
      kind: Question
      title: 'How much difficulty? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
        hint: Not asked when the child has no problem seeing.
      - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
        hint: Not asked when the child has no problem seeing.
      - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
        hint: Not asked when the child cannot see.
      - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 2)
        hint: Not asked when the child cannot see.
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_vision_diag
    title: Legal blindness and vision aids used
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    items:
    - id: B16
      kind: Question
      title: Has ..... been diagnosed by an eye specialist as being legally blind?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: B17
      kind: Question
      title: Does ..... USE any aids or specialized equipment for children with vision difficulties, for example, magnifiers or Braille reading materials?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_vision_now
    title: Vision aids now used
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    - predicate: not (B17.outcome in [3, 98])
      hint: Asked only when question B17 is none of "(3) No", "(x) Don’t know".
    items:
    - id: B18_a
      kind: Question
      title: 'Does he/she now use: (a) magnifiers Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_b
      kind: Question
      title: 'Does he/she now use: (b) Braille reading materials'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_c
      kind: Question
      title: 'Does he/she now use: (c) large print reading materials'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_d
      kind: Question
      title: 'Does he/she now use: (d) talking books'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_e
      kind: Question
      title: 'Does he/she now use: (e) recording equipment'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_f
      kind: Question
      title: 'Does he/she now use: (f) a closed circuit TV'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_g
      kind: Question
      title: 'Does he/she now use: (g) a computer with Braille, large print, or speech access'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B18_h
      kind: Question
      title: 'Does he/she now use: (h) other aid, specify'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p1_vision_need
    title: Vision aids needed
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    items:
    - id: B19
      kind: Question
      title: Are there any aids or specialized equipment for children with vision difficulties that ..... CURRENTLY needs, but does not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_vision_need_which
    title: Which vision aids needed
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 2)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    - predicate: not (B19.outcome in [3, 98])
      hint: Asked only when question B19 is none of "(3) No", "(x) Don’t know".
    items:
    - id: B20
      kind: Question
      title: 'Which aids does he/she NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Glasses or contact lenses
          2: (b) Magnifiers
          4: (c) Braille reading materials
          8: (d) Large print reading materials
          16: (e) Talking books
          32: (f) Recording equipment
          64: (g) A closed circuit TV
          128: (h) A computer with Braille, large print, or speech access
          256: (i) Other aid, specify
          512: (x) Don’t know
          1024: (r) Refusal
  - id: b_s3_p1_speech_start
    title: Speaking
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    items:
    - id: B21
      kind: Question
      title: Because of a condition or health problem, does ..... have any difficulty speaking?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: B22
      kind: Question
      title: Because of a condition or health problem, does ..... have any difficulty making himself/herself understood when speaking?
      precondition:
      - predicate: not (B21.outcome == 1)
        hint: Asked only when question B21 is not "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p1_speech_detail
    title: Speaking difficulty detail
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child has no problem seeing.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when the child cannot see.
    - predicate: not (B22.outcome == 98)
      hint: Asked only when question B22 is not "(x) Don’t know".
    items:
    - id: B23
      kind: Question
      title: 'How much difficulty does he/she have speaking? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Child has some difficulty
          2: (2) Child has a lot of difficulty
          3: (3) Child cannot speak
          98: (x) Don’t know
          99: (r) Refusal
    - id: B24
      kind: Question
      title: Because of a condition or health problem, does ..... have any difficulty making himself/herself understood when speaking?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: B25_a
      kind: Question
      title: 'How well do you feel ..... is able to make himself/herself understood when speaking with: (a) his/her family members? Interviewer: Read categories. Mark one only. Read list.'
      input:
        control: Radio
        labels:
          1: (1) Completely
          2: (2) Partially
          3: (3) Not at all
          98: (x) DK
          99: (r) Ref
    - id: B25_b
      kind: Question
      title: 'How well do you feel ..... is able to make himself/herself understood when speaking with: (b) his/her friends?'
      input:
        control: Radio
        labels:
          1: (1) Completely
          2: (2) Partially
          3: (3) Not at all
          98: (x) DK
          99: (r) Ref
    - id: B25_c
      kind: Question
      title: 'How well do you feel ..... is able to make himself/herself understood when speaking with: (c) other people?'
      input:
        control: Radio
        labels:
          1: (1) Completely
          2: (2) Partially
          3: (3) Not at all
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p2_speech_comm
    title: 'Speaking: ways of communicating and aids used'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B22.outcome == 98)
      hint: Asked only when B22 is not Don't know.
    items:
    - id: B26_a
      kind: Question
      title: 'Does he/she use: (a) Sign language, such as ASL or LSQ Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B26_b
      kind: Question
      title: 'Does he/she use: (b) other form of communication, specify'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B27
      kind: Question
      title: Does ..... USE any aids or specialized equipment for children who have difficulty speaking or making themselves understood, for example, a voice amplifier or Blissboard?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p2_speech_now_use
    title: 'Speaking: aids now used'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B22.outcome == 98)
      hint: Asked only when B22 is not Don't know.
    - predicate: not (B27.outcome in [3, 98])
      hint: Asked only when B27 is none of No, Don't know.
    items:
    - id: B28_a
      kind: Question
      title: 'Does he/she now use: (a) a voice amplifier Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B28_b
      kind: Question
      title: 'Does he/she now use: (b) a computer or keyboard device to communicate'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B28_c
      kind: Question
      title: 'Does he/she now use: (c) a communication board, such as a Blissboard'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B28_d
      kind: Question
      title: 'Does he/she now use: (d) other aid, specify'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p2_speech_need
    title: 'Speaking: aids needed'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B22.outcome == 98)
      hint: Asked only when B22 is not Don't know.
    items:
    - id: B29
      kind: Question
      title: Are there any aids or specialized equipment for children who have difficulty speaking or making themselves understood that ..... CURRENTLY needs, but does not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p2_speech_need_which
    title: 'Speaking: which aids are needed'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B22.outcome == 98)
      hint: Asked only when B22 is not Don't know.
    - predicate: not (B29.outcome in [3, 98])
      hint: Asked only when B29 is none of No, Don't know.
    items:
    - id: B30
      kind: Question
      title: 'Which aids does he/she NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) A voice amplifier
          2: (b) A computer or keyboard device to communicate
          4: (c) A communication board, such as a Blissboard
          8: (d) Other aid, specify
          16: (x) Don’t know
          32: (r) Refusal
  - id: b_s3_p2_walking
    title: Walking
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    items:
    - id: B31
      kind: Question
      title: 'The next few questions are about .....’s ability to move around, even when using an aid or mechanical support, such as crutches or a walker. Please remember that I am asking about difficulties that have lasted or are expected to last six months or more. Because of a condition or health problem, does ..... have any difficulty walking? This means walking on a flat firm surface, such as a sidewalk or floor. Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p2_walking_detail
    title: 'Walking: difficulty and aid use'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B31.outcome == 98)
      hint: Asked only when B31 is not Don't know.
    items:
    - id: B32
      kind: Question
      title: 'How much difficulty does he/she have walking? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          3: (3) Child cannot walk
          98: (x) Don’t know
          99: (r) Refusal
    - id: B33
      kind: Question
      title: Does ..... USE any aids or specialized equipment for children who have difficulty walking or moving around, such as a cane or crutches?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p2_walking_now_use
    title: 'Walking: aids now used'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B31.outcome == 98)
      hint: Asked only when B31 is not Don't know.
    - predicate: not (B33.outcome in [3, 98])
      hint: Asked only when B33 is none of No, Don't know.
    items:
    - id: B34_a
      kind: Question
      title: 'Does he/she now use: (a) orthopaedic or medically prescribed shoes Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_b
      kind: Question
      title: 'Does he/she now use: (b) a cane or crutches'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_c
      kind: Question
      title: 'Does he/she now use: (c) a walker'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_d
      kind: Question
      title: 'Does he/she now use: (d) a manual wheelchair'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_e
      kind: Question
      title: 'Does he/she now use: (e) an electric wheelchair'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_f
      kind: Question
      title: 'Does he/she now use: (f) braces, such as a leg brace (Exclude dental braces.)'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_g
      kind: Question
      title: 'Does he/she now use: (g) lift devices, such as a bed lift device'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
    - id: B34_h
      kind: Question
      title: 'Does he/she now use: (h) other aid, specify'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) DK
          99: (r) Ref
  - id: b_s3_p2_walking_need
    title: 'Walking: aids needed'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B31.outcome == 98)
      hint: Asked only when B31 is not Don't know.
    items:
    - id: B35
      kind: Question
      title: Are there any aids or specialized equipment for children who have difficulty walking or moving around that ..... CURRENTLY needs, but does not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s3_p2_walking_need_which
    title: 'Walking: which aids are needed'
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    - predicate: not (B31.outcome == 98)
      hint: Asked only when B31 is not Don't know.
    - predicate: not (B35.outcome in [3, 98])
      hint: Asked only when B35 is none of No, Don't know.
    items:
    - id: B36
      kind: Question
      title: 'Which aids does he/she NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Orthopaedic or medically prescribed shoes
          2: (b) A cane or crutches
          4: (c) A walker
          8: (d) A manual wheelchair
          16: (e) An electric wheelchair
          32: (f) Braces, such as a leg brace (Exclude dental braces.)
          64: (g) Lift devices, such as a bed lift device
          128: (h) Other aid, specify
          256: (x) Don’t know
          512: (r) Refusal
  - id: b_s3_p2_hands
    title: Hands and fingers
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B12 is Yes and the child was born after May 15, 1996.
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child was not born after May 15, 1996.
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is Yes and the child was born after May 15, 1996.
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 is No and the child was born after May 15, 1996.
    items:
    - id: B37
      kind: Question
      title: 'Because of a condition or health problem, does ..... have any difficulty USING his/her HANDS or FINGERS to grasp or hold small objects, such as a pencil or scissors? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s4_p1_hands
    title: Hands and fingers
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child is not both in B12 = Yes and born after May 15, 1996
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 = Yes and the child was born after May 15, 1996
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 = No and the child was born after May 15, 1996
    - predicate: not (B37.outcome == 98)
      hint: Asked only when question B37 is not "(x) Don’t know".
    items:
    - id: B38
      kind: Question
      title: 'How much difficulty? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Some difficulty
          2: (2) A lot of difficulty
          3: (3) Completely unable
          8: (x) Don’t know
          9: (r) Refusal
    - id: B39
      kind: Question
      title: 'Does ..... USE any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers, such as a hand or arm brace, or grasping tools? [If Yes (1): Check box “Hands/Fingers — USE Aid” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B40a
      kind: Question
      title: 'B40. Does he/she now use: (a) a hand or arm brace. Interviewer: Read list.'
      precondition:
      - predicate: not (B39.outcome == 8)
        hint: Asked only when question B39 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B40b
      kind: Question
      title: 'B40. Does he/she now use: (b) grasping tools or reach extenders.'
      precondition:
      - predicate: not (B39.outcome == 8)
        hint: Asked only when question B39 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B40c
      kind: Question
      title: 'B40. Does he/she now use: (c) other aid, specify'
      precondition:
      - predicate: not (B39.outcome == 8)
        hint: Asked only when question B39 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B41
      kind: Question
      title: 'Are there any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers that ..... CURRENTLY needs, but does not have? [If Yes (1): Check box “Hands/Fingers — NEED Aid” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B42
      kind: Question
      title: 'Which aids does he/she NEED, but does not have? Interviewer: Do NOT read list.Mark all that apply.'
      precondition:
      - predicate: not (B41.outcome == 8)
        hint: Asked only when question B41 is not "(x) Don’t know".
      input:
        control: Checkbox
        labels:
          1: (a) A hand or arm brace
          2: (b) Grasping tools or reach extenders
          4: (c) Other aid, specify
          8: (x) Don’t know
          16: (r) Refusal
  - id: b_s4_p1_learning
    title: Learning
    precondition:
    - predicate: not (B12.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when the child is not both in B12 = Yes and born after May 15, 1996
    - predicate: not (BORN_AFTER_19960515.outcome == 1)
      hint: Asked only when question BORN_AFTER_19960515 is not "Born AFTER May 15, 1996".
    - predicate: not (B14.outcome == 1 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 = Yes and the child was born after May 15, 1996
    - predicate: not (B14.outcome == 3 and BORN_AFTER_19960515.outcome == 1)
      hint: Not asked when B14 = No and the child was born after May 15, 1996
    items:
    - id: B43
      kind: Question
      title: 'Do you think that ..... has a learning disability, such as dyslexia, hyperactivity or attention problems? [If Yes (1): Check box “Learning — Limitation” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B44
      kind: Question
      title: 'Has a teacher, doctor or other health professional ever said that ..... had a learning disability? [If Yes (1): Check box “Learning — Limitation” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B45
      kind: Question
      title: '[B45 edit] Does this condition reduce the amount or the kind of activities ..... can do? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B46a
      kind: Question
      title: 'B46. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? Interviewer: Read categories.Mark one only.'
      precondition:
      - predicate: not (B45.outcome == 8)
        hint: Asked only when question B45 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B46b
      kind: Question
      title: 'B46. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (b) at school?'
      precondition:
      - predicate: not (B45.outcome == 8)
        hint: Asked only when question B45 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B46c
      kind: Question
      title: 'B46. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (c) at play or recreational activities?'
      precondition:
      - predicate: not (B45.outcome == 8)
        hint: Asked only when question B45 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B47
      kind: Question
      title: 'Does ..... USE any aids, specialized equipment or services to help him/her with his/her learning difficulty? [If Yes (1): Check box “Learning — USE Aid” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B48a
      kind: Question
      title: 'B48. Does he/she now use: (a) a computer as a learning aid. Interviewer: Read list.'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B48b
      kind: Question
      title: 'B48. Does he/she now use: (b) a voice activated or voice synthesis computer software (e.g.Dragon Dictate, Via Voice)'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B48c
      kind: Question
      title: 'B48. Does he/she now use: (c) talking books.'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B48d
      kind: Question
      title: 'B48. Does he/she now use: (d) recording equipment'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B48e
      kind: Question
      title: 'B48. Does he/she now use: (e) a tutor'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B48f
      kind: Question
      title: 'B48. Does he/she now use: (f) other aid, specify'
      precondition:
      - predicate: not (B47.outcome == 8)
        hint: Asked only when question B47 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B49
      kind: Question
      title: '[B49 edit] Are there any learning aids, specialized equipment or services that ..... CURRENTLY needs, but does not have? [If Yes (1): Check box “Learning — NEED Aid” on Profile Sheet] Interviewer: If B43 OR B44 is “Yes”,continue.Otherwise,go to B53 (page 12).'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B50
      kind: Question
      title: 'Which aids or services does he/she NEED, but does not have? Interviewer: Do NOT read list.Mark all that apply.'
      precondition:
      - predicate: not (B49.outcome == 8)
        hint: Asked only when question B49 is not "(x) Don’t know".
      - predicate: not (not (B43.outcome == 1 or B44.outcome == 1))
        hint: Asked only when B43 or B44 is Yes.
      input:
        control: Checkbox
        labels:
          1: (a) A computer as a learning aid
          2: (b) A voice activated or voice synthesis computer software (e.g.Dragon Dictate, Via Voice)
          4: (c) Talking books
          8: (d) Recording equipment
          16: (e) A tutor
          32: (f) Other aid, specify
          64: (x) Don’t know
          128: (r) Refusal
  - id: b_s4_p1_dev_screen
    title: Developmental delay
    precondition:
    - predicate: not (not (B43.outcome == 1 or B44.outcome == 1))
      hint: Asked only when B43 or B44 is Yes.
    items:
    - id: B51
      kind: Question
      title: '[B51 edit] Because of a condition or health problem, does ..... have a delay in his/her development, either a physical, intellectual or another type of delay? [If Yes (1): Check box “Developmental — Limitation” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p1_dev_kind
    title: Kind of delay
    precondition:
    - predicate: not (not (B43.outcome == 1 or B44.outcome == 1))
      hint: Asked only when B43 or B44 is Yes.
    - predicate: not (B51.outcome == 3)
      hint: Asked only when question B51 is not "(3) No".
    items:
    - id: B52a
      kind: Question
      title: 'B52. What kind of delay is this? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) A delay in his/her PHYSICAL development'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B52b
      kind: Question
      title: B52. What kind of delay is this? (b) A delay in his/her INTELLECTUAL development
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B52c
      kind: Question
      title: B52. What kind of delay is this? (c) Other type of delay, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p1_devdis
    title: Developmental disability
    items:
    - id: B53
      kind: Question
      title: '[B53 edit] Has a doctor, psychologist or other health professional ever said that ..... has a developmental disability or disorder? These may include autism, Down syndrome, or mental impairment due to a lack of oxygen at birth. [If Yes (1): Check box “Developmental — Limitation” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p1_devact
    title: 'Developmental disability: activity reduction'
    precondition:
    - predicate: not (B53.outcome == 8)
      hint: Asked only when question B53 is not "(x) Don’t know".
    items:
    - id: B54
      kind: Question
      title: 'Does this condition reduce the amount or the kind of activities ..... can do? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B55a
      kind: Question
      title: 'B55. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? Interviewer: Read categories.Mark one only.'
      precondition:
      - predicate: not (B54.outcome == 8)
        hint: Asked only when question B54 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B55b
      kind: Question
      title: 'B55. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (b) at school?'
      precondition:
      - predicate: not (B54.outcome == 8)
        hint: Asked only when question B54 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B55c
      kind: Question
      title: 'B55. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (c) at play or recreational activities?'
      precondition:
      - predicate: not (B54.outcome == 8)
        hint: Asked only when question B54 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p1_emotional
    title: Emotional, psychological or behavioural conditions
    items:
    - id: B56
      kind: Question
      title: Does ..... have any emotional, psychological or behavioural conditions that have lasted or are expected to last six months or more?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B57
      kind: Question
      title: 'Does this condition reduce the amount or the kind of activities ..... can do? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B58a
      kind: Question
      title: 'B58. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? Interviewer: Read categories.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B58b
      kind: Question
      title: 'B58. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (b) at school?'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B58c
      kind: Question
      title: 'B58. How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (c) at play or recreational activities? [Check box “Emotional/Psychological — Limitation” on Profile Sheet]'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p1_chronic
    title: Chronic conditions
    items:
    - id: B59a
      kind: Question
      title: 'B59. Now I’d like to ask about any CHRONIC health conditions ..... may have. (Chronic conditions refer to conditions that have lasted or are expected to last six months or more.) Does ..... have any of the following LONG-TERM conditions which have been DIAGNOSED by a health professional? Interviewer: Read list. (a) Asthma or severe allergies'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59b
      kind: Question
      title: B59. (b) Heart condition or disease
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59c
      kind: Question
      title: B59. (c) Kidney condition or disease
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59d
      kind: Question
      title: B59. (d) Cancer
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59e
      kind: Question
      title: B59. (e) Diabetes
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59f
      kind: Question
      title: B59. (f) Epilepsy
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59g
      kind: Question
      title: B59. (g) Autism
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59h
      kind: Question
      title: B59. (h) Cerebral Palsy
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59i
      kind: Question
      title: B59. (i) Spina Bifida
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59j
      kind: Question
      title: B59. (j) Cystic Fibrosis
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59k
      kind: Question
      title: B59. (k) Muscular Dystrophy
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59l
      kind: Question
      title: B59. (l) Migraines
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59m
      kind: Question
      title: B59. (m) Arthritis or rheumatism
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59n
      kind: Question
      title: B59. (n) Paralysis of any kind
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59o
      kind: Question
      title: B59. (o) Missing or malformed arms, legs, fingers or toes
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59p
      kind: Question
      title: B59. (p) Fetal Alcohol Syndrome
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59q
      kind: Question
      title: B59. (q) Attention Deficit Disorder (ADD) or Attention Deficit Hyperactivity Disorder (ADHD)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59r
      kind: Question
      title: B59. (r) Down syndrome
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59s
      kind: Question
      title: B59. (s) Complex medical care needs
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B59t
      kind: Question
      title: B59. (t) Any other LONG-TERM condition that has been diagnosed by a health professional, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p1_chronic_effect
    title: 'Chronic conditions: activity reduction'
    precondition:
    - predicate: not (B59a.outcome != 1 and B59b.outcome != 1 and B59c.outcome != 1 and B59d.outcome != 1 and B59e.outcome != 1 and B59f.outcome != 1 and B59g.outcome != 1 and B59h.outcome != 1 and B59i.outcome != 1 and B59j.outcome != 1 and B59k.outcome != 1 and B59l.outcome != 1 and B59m.outcome != 1 and B59n.outcome != 1 and B59o.outcome != 1 and B59p.outcome != 1 and B59q.outcome != 1 and B59r.outcome != 1 and B59s.outcome != 1 and B59t.outcome != 1)
      hint: Asked only when at least one chronic condition in B59 is Yes.
    items:
    - id: B60
      kind: Question
      title: '[B60 edit] Does this condition (Do these conditions) reduce the amount or the kind of activities ..... can do? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Yes, sometimes
          2: (2) Yes, often or always
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B61a
      kind: Question
      title: 'B61. How many ACTIVITIES does this condition (do these conditions) USUALLY prevent him/her from doing: (a) at home? Interviewer: Read categories.Mark one only.'
      precondition:
      - predicate: not (B60.outcome == 8)
        hint: Asked only when question B60 is not "(x) Don’t know".
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p2_limitation_school
    title: Limitations at school and at play
    precondition:
    - predicate: not (B59a.outcome != 1 and B59b.outcome != 1 and B59c.outcome != 1 and B59d.outcome != 1 and B59e.outcome != 1 and B59f.outcome != 1 and B59g.outcome != 1 and B59h.outcome != 1 and B59i.outcome != 1 and B59j.outcome != 1 and B59k.outcome != 1 and B59l.outcome != 1 and B59m.outcome != 1 and B59n.outcome != 1 and B59o.outcome != 1 and B59p.outcome != 1 and B59q.outcome != 1 and B59r.outcome != 1 and B59s.outcome != 1 and B59t.outcome != 1)
      hint: Asked only when at least one B59 item is Yes.
    - predicate: not (B60.outcome == 8)
      hint: Asked only when question B60 is not "(x) Don’t know".
    items:
    - id: B61b
      kind: Question
      title: B61. ... (b) at school?
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
    - id: B61c
      kind: Question
      title: B61. ... (c) at play or recreational activities? [Check box “Chronic — Limitation” on Profile Sheet]
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) A few
          3: (3) Many
          4: (4) Most
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p2_condition
    title: Main condition and diagnosis
    items:
    - id: B62
      kind: Question
      title: '[B62 edit] You mentioned earlier that because of a physical condition, mental condition or health problem ..... has difficulties or activity limitations. How old was ..... when you suspected that he/she has a long-term condition or health problem? (0-14) Years Interviewer: If age is less than 1 year, enter 00. (98 = Don’t know, 99 = Refusal)'
      input:
        control: Editbox
        min: 0
        max: 99
        right: years
    - id: B63
      kind: Question
      title: 'What is the MAIN condition or health problem which causes him/her difficulties or activity limitations? Interviewer: Specify ONE condition or health problem only.'
      input:
        control: Textarea
    - id: B64
      kind: Question
      title: 'Which one of the following best describes the CAUSE of this condition or health problem? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Existed at birth, was due to premature birth or accident at birth
          2: (2) A disease or illness
          3: (3) Accident at home or at school
          4: (4) Motor vehicle accident
          5: (5) Other, specify
          8: (x) Don’t know
          9: (r) Refusal
    - id: B65
      kind: Question
      title: Did you get a diagnosis for .....’s condition or health problem?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_diagnosis
    title: Obtaining a diagnosis
    precondition:
    - predicate: not (B65.outcome == 8)
      hint: Asked only when question B65 is not "(x) Don’t know".
    items:
    - id: B66
      kind: Question
      title: 'How old was ..... when you obtained a diagnosis for his/her condition or health problem? (0-14) Years Interviewer: If age is less than 1 year, enter 00. (98 = Don’t know, 99 = Refusal)'
      input:
        control: Editbox
        min: 0
        max: 99
        right: years
    - id: B67a
      kind: Question
      title: 'B67. Did you experience any of the following situations when you were trying to obtain a diagnosis for .....’s condition or health problem? Interviewer: Read list. (a) Doctor or health professional took a wait and see approach'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67b
      kind: Question
      title: B67. (b) Long waiting period to get the diagnosis
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67c
      kind: Question
      title: B67. (c) Difficulty getting referrals or appointments
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67d
      kind: Question
      title: B67. (d) Doctor or health professional not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67e
      kind: Question
      title: B67. (e) Too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67f
      kind: Question
      title: B67. (f) Did not know where to get the diagnosis
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B67g
      kind: Question
      title: B67. (g) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p2_health_meds
    title: General health and regular medications
    items:
    - id: B68
      kind: Question
      title: 'How would you describe .....’s general health? Would you say that his/her health is: Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) excellent?
          2: (2) very good?
          3: (3) good?
          4: (4) fair?
          5: (5) poor?
          8: (x) Don’t know
          9: (r) Refusal
    - id: B69
      kind: Question
      title: The next questions are about the use of medications or drugs. Does ..... USE any prescription or non-prescription medications on a regular basis, that is, AT LEAST ONCE A WEEK?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_meds_detail
    title: Medication details
    precondition:
    - predicate: not (B69.outcome == 8)
      hint: Asked only when question B69 is not "(x) Don’t know".
    items:
    - id: B70
      kind: Question
      title: 'How many kinds of PRESCRIPTION medications does he/she take EVERYDAY? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) 1-3 kinds
          3: (3) 4 kinds or more
          8: (x) Don’t know
          9: (r) Refusal
    - id: B71
      kind: Question
      title: 'How many kinds of NON-PRESCRIPTION medications does he/she take EVERYDAY? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) 1-3 kinds
          3: (3) 4 kinds or more
          8: (x) Don’t know
          9: (r) Refusal
    - id: B72
      kind: Question
      title: Does ..... USE any medications regularly, but NOT DAILY?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_meds_not_daily
    title: Medications taken regularly but not daily
    precondition:
    - predicate: not (B69.outcome == 8)
      hint: Asked only when question B69 is not "(x) Don’t know".
    - predicate: not (B72.outcome == 8)
      hint: Asked only when question B72 is not "(x) Don’t know".
    items:
    - id: B73
      kind: Question
      title: 'How many kinds of PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) 1-3 kinds
          3: (3) 4 kinds or more
          8: (x) Don’t know
          9: (r) Refusal
    - id: B74
      kind: Question
      title: 'How many kinds of NON-PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)? Interviewer: Read list.Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) None
          2: (2) 1-3 kinds
          3: (3) 4 kinds or more
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_med_expenses_screen
    title: Medication expenses
    items:
    - id: B75
      kind: Question
      title: IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for .....’s prescription or non-prescription medications?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_med_expenses
    title: Medication expense amount
    precondition:
    - predicate: not (B75.outcome == 8)
      hint: Asked only when question B75 is not "(x) Don’t know".
    items:
    - id: B76
      kind: Question
      title: 'What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program. $ .00 Range: 1-999999 (9999998 = Don’t know, 9999999 = Refusal)'
      input:
        control: Editbox
        min: 1
        max: 9999999
        left: $
    - id: B77
      kind: Question
      title: 'Which one of the following expense groups is the best estimate of the direct costs to you or your family? I will read you a list. Interviewer: Read list.Mark one only.'
      precondition:
      - predicate: not (B76.outcome != 9999998 and B76.outcome != 9999999)
        hint: Asked only when B76 is Don’t know or Refusal.
      input:
        control: Radio
        labels:
          1: (1) Less than $100
          2: (2) $100 to less than $200
          3: (3) $200 to less than $500
          4: (4) $500 to less than $1000
          5: (5) $1000 to less than $2000
          6: (6) $2000 to less than $5000
          7: (7) $5000 or more
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s4_p2_unmet_meds
    title: Medications needed but not had
    items:
    - id: B78
      kind: Question
      title: Because of a condition or health problem, does ..... CURRENTLY need any prescription or non-prescription medications on a regular basis, which he/she does not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B79a
      kind: Question
      title: 'B79. Why doesn’t he/she have these medications? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Not covered by insurance'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B79b
      kind: Question
      title: B79. (b) Too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B79c
      kind: Question
      title: B79. (c) Not approved or recommended by health professionals
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B79d
      kind: Question
      title: B79. (d) Other reason, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p2_professionals
    title: Contact with health professionals
    items:
    - id: B80a
      kind: Question
      title: 'B80. The next few questions are about your contact with health professionals because of .....’s condition or health problem. IN THE PAST 12 MONTHS, how OFTEN has ..... seen or received care from a: Interviewer: Read categories.Mark one only. (a) family doctor or general practitioner?'
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80b
      kind: Question
      title: B80. ... (b) medical specialist (such as a heart specialist)?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80c
      kind: Question
      title: B80. ... (c) nurse?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80d
      kind: Question
      title: B80. ... (d) speech therapist?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80e
      kind: Question
      title: B80. ... (e) physiotherapist?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80f
      kind: Question
      title: B80. ... (f) psychologist or psychotherapist?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80g
      kind: Question
      title: B80. ... (g) chiropractor?
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
    - id: B80h
      kind: Question
      title: B80. ... (h) other health professional, specify
      input:
        control: Radio
        labels:
          1: (1) At least once a week
          2: (2) At least once a month
          3: (3) Less than once a month
          4: (4) Never
          8: (x) DK
          9: (r) Ref
  - id: b_s4_p2_professional_costs
    title: Costs of health professional services
    precondition:
    - predicate: not (B80a.outcome not in [1, 2, 3] and B80b.outcome not in [1, 2, 3] and B80c.outcome not in [1, 2, 3] and B80d.outcome not in [1, 2, 3] and B80e.outcome not in [1, 2, 3] and B80f.outcome not in [1, 2, 3] and B80g.outcome not in [1, 2, 3] and B80h.outcome not in [1, 2, 3])
      hint: Asked only when the child had contact with at least one health professional in B80.
    items:
    - id: B81
      kind: Question
      title: '[B81 edit] IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the services that ..... received from health professionals?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B82
      kind: Question
      title: 'What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program. $ .00 Range: 1-999999 (9999998 = Don’t know, 9999999 = Refusal)'
      precondition:
      - predicate: not (B81.outcome == 8)
        hint: Asked only when question B81 is not "(x) Don’t know".
      input:
        control: Editbox
        min: 1
        max: 9999999
        left: $
    - id: ProfileSheet_Limitation_Any
      kind: Question
      title: 'External input: whether any box is checked in the “Limitation Column” on the Profile Sheet (set by the check-box instructions in this part and earlier parts)'
      external: true
      precondition:
      - predicate: not (B81.outcome == 8)
        hint: Asked only when question B81 is not "(x) Don’t know".
      - predicate: not (B82.outcome != 9999998 and B82.outcome != 9999999)
        hint: Asked only when B82 is Don’t know or Refusal.
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s5_external
    title: External inputs
    precondition:
    - predicate: not (B80a.outcome not in [1, 2, 3] and B80b.outcome not in [1, 2, 3] and B80c.outcome not in [1, 2, 3] and B80d.outcome not in [1, 2, 3] and B80e.outcome not in [1, 2, 3] and B80f.outcome not in [1, 2, 3] and B80g.outcome not in [1, 2, 3] and B80h.outcome not in [1, 2, 3])
      hint: Asked only when at least one of B80a to B80h was answered.
    - predicate: not (B81.outcome == 8)
      hint: Asked only when question B81 is not "(x) Don’t know".
    - predicate: not (B82.outcome != 9999998 and B82.outcome != 9999999)
      hint: Asked only when B82 is Don’t know or Refusal.
    items:
    - id: BORN_AFTER_1996_05_15
      kind: Question
      title: 'External input: whether the child was born AFTER May 15, 1996 (from the child''s date of birth in the sample or household file); used by the interviewer instructions at B87.edit and C3'
      external: true
      input:
        control: Radio
        labels:
          1: Yes, born after May 15, 1996
          3: No, born on or before May 15, 1996
    - id: PROFILE_USE_AID_ANY
      kind: Question
      title: 'External input: whether any box is checked in the "USE — Aid" column on the Profile Sheet'
      external: true
      input:
        control: Radio
        labels:
          1: Yes, at least one box checked
          3: No box checked
    - id: PROFILE_NEED_AID_ANY
      kind: Question
      title: 'External input: whether any box is checked in the "NEED Aid" column on the Profile Sheet'
      external: true
      input:
        control: Radio
        labels:
          1: Yes, at least one box checked
          3: No box checked
  - id: b_s5_cost_group
    title: Direct costs
    precondition:
    - predicate: not (B80a.outcome not in [1, 2, 3] and B80b.outcome not in [1, 2, 3] and B80c.outcome not in [1, 2, 3] and B80d.outcome not in [1, 2, 3] and B80e.outcome not in [1, 2, 3] and B80f.outcome not in [1, 2, 3] and B80g.outcome not in [1, 2, 3] and B80h.outcome not in [1, 2, 3])
      hint: Asked only when at least one of B80a to B80h was answered.
    - predicate: not (B81.outcome == 8)
      hint: Asked only when question B81 is not "(x) Don’t know".
    - predicate: not (B82.outcome != 9999998 and B82.outcome != 9999999)
      hint: Asked only when B82 is Don’t know or Refusal.
    items:
    - id: B83
      kind: Question
      title: 'Which one of the following expense groups is the best estimate of the direct costs to you or your family? I will read you a list. Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Less than $200
          2: (2) $200 to less than $500
          3: (3) $500 to less than $1000
          4: (4) $1000 to less than $2000
          5: (5) $2000 to less than $5000
          6: (6) $5000 or more
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s5_unmet_screen
    title: Unmet need for health services
    items:
    - id: B84
      kind: Question
      title: IN THE PAST 12 MONTHS, was there ever a time when ..... needed health services because of his/her condition, but did not receive them?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s5_unmet_detail
    title: Health services needed but not received
    precondition:
    - predicate: not (B84.outcome in [3, 8, 9] and BORN_AFTER_1996_05_15.outcome != 1)
      hint: Asked when B84 is Yes, or when the child was born after May 15, 1996.
    items:
    - id: B85
      kind: Question
      title: 'What kind of health services did he/she NEED, but did not receive? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Family doctor or general practitioner
          2: (b) Medical specialist (such as a heart specialist)
          4: (c) Nurse for care
          8: (d) Speech therapist
          16: (e) Physiotherapist
          32: (f) Psychologist or psychotherapist
          64: (g) Chiropractor
          128: (h) Other, specify
          256: (x) Don’t know
          512: (r) Refusal
    - id: B86_a
      kind: Question
      title: B86. Why didn’t ..... receive the health service that he/she needed? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B86_b
      kind: Question
      title: B86 (b) Too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B86_c
      kind: Question
      title: B86 (c) Not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B86_d
      kind: Question
      title: B86 (d) Long waiting period
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B86_e
      kind: Question
      title: B86 (e) Other reason, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s5_aids_use
    title: Aids and specialized equipment in use
    items:
    - id: B87
      kind: Question
      title: 'Because of a condition or health problem, does ..... USE any aids or specialized equipment that you have not already mentioned? (Yes: check box “Chronic/Other — USE Aid” on Profile Sheet)'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B88_a
      kind: Question
      title: 'B88. Does he/she now use: (a) respiratory aids, such as inhalers, puffers, oxygen'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B88_b
      kind: Question
      title: B88 (b) pain management aids, such as a TENS machine
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B88_c
      kind: Question
      title: B88 (c) other aid or specialized equipment, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B89_a
      kind: Question
      title: B89. I would like you to think about all the aids and specialized equipment that ..... currently uses. What kind of funding was used to get these aids? I will read you a list. Please answer yes or no to each. (a) Your own money
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B89_b
      kind: Question
      title: B89 (b) Friends and family members
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B89_c
      kind: Question
      title: B89 (c) Private health insurance
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B89_d
      kind: Question
      title: B89 (d) Government program
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B89_e
      kind: Question
      title: B89 (e) Other funding, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B90
      kind: Question
      title: IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for the purchase or maintenance of aids or specialized equipment that ..... uses?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s5_out_of_pocket
    title: Out-of-pocket costs of aids
    precondition:
    - predicate: not (B90.outcome in [3, 8, 9])
      hint: Asked only when question B90 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: B91
      kind: Question
      title: 'What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program. $ .00 Range: 1-999999 (9999998 = Don’t know, 9999999 = Refusal)'
      input:
        control: Editbox
        min: 1
        max: 9999999
        left: $
    - id: B92
      kind: Question
      title: 'Which one of the following expense groups is the best estimate of the direct costs to you or your family? I will read you a list. Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (B91.outcome >= 1 and B91.outcome <= 999999)
        hint: Asked only when B91 was not given as an amount.
      - predicate: not (PROFILE_USE_AID_ANY.outcome == 3)
        hint: Asked only when question PROFILE_USE_AID_ANY is not "No box checked".
      input:
        control: Radio
        labels:
          1: (1) Less than $200
          2: (2) $200 to less than $500
          3: (3) $500 to less than $1000
          4: (4) $1000 to less than $2000
          5: (5) $2000 to less than $5000
          6: (6) $5000 or more
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s5_aids_need
    title: Aids and specialized equipment needed
    items:
    - id: B93
      kind: Question
      title: 'Does ..... CURRENTLY need any aids or specialized equipment that you have not already mentioned? (Yes: check box “Chronic/Other — NEED Aid” on Profile Sheet)'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: B94
      kind: Question
      title: 'Which aids does ..... NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Respiratory aids, such as inhalers, puffers, oxygen
          2: (b) Pain management aids, such as a TENS machine
          4: (c) Other aid or specialized equipment, specify
          8: (x) Don’t know
          16: (r) Refusal
    - id: B95_a
      kind: Question
      title: B95. I would like you to think about all the aids ..... CURRENTLY needs, but does not have. Why doesn’t he/she have these aids or specialized equipment? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_b
      kind: Question
      title: B95 (b) Too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_c
      kind: Question
      title: B95 (c) Not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_d
      kind: Question
      title: B95 (d) Do not know where to obtain the aid
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_e
      kind: Question
      title: B95 (e) Child’s condition is not serious enough
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_f
      kind: Question
      title: B95 (f) Only needed occasionally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B95_g
      kind: Question
      title: B95 (g) Other reason, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s5_need_impact_screen
    title: Impact of not having needed aids
    precondition:
    - predicate: not (PROFILE_NEED_AID_ANY.outcome == 3)
      hint: Asked only when question PROFILE_NEED_AID_ANY is not "No box checked".
    items:
    - id: B96
      kind: Question
      title: Now, I would like you to think about all the aids or specialized equipment that he/she NEEDS, but does not have. Do you think that there is an impact on ..... because he/she does not have these aids?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s5_need_impact_detail
    title: Kinds of impact
    precondition:
    - predicate: not (PROFILE_NEED_AID_ANY.outcome == 3)
      hint: Asked only when question PROFILE_NEED_AID_ANY is not "No box checked".
    - predicate: not (B96.outcome in [3, 8, 9])
      hint: Asked only when question B96 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: B97_a
      kind: Question
      title: B97. What is the impact of not having these aids or specialized equipment? I will read you a list. Please answer yes or no to each. (a) Child’s participation in regular everyday activity is reduced
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B97_b
      kind: Question
      title: B97 (b) Child is frustrated
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B97_c
      kind: Question
      title: B97 (c) Child’s self-esteem is affected
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: B97_d
      kind: Question
      title: B97 (d) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_personal_care
    title: Help with personal care
    items:
    - id: C1
      kind: Question
      title: Does ..... USUALLY receive help with personal care, such as bathing, toiletting, dressing or feeding?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_personal_care_followup
    title: Personal care help details
    precondition:
    - predicate: not (C1.outcome in [3, 8, 9])
      hint: Asked only when question C1 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: C2
      kind: Question
      title: Is this because of his/her condition or health problem?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: C3
      kind: Question
      title: 'How much help does he/she need? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (C2.outcome in [3, 8, 9])
        hint: Asked only when question C2 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
      input:
        control: Radio
        labels:
          1: (1) Some help
          2: (2) A lot of help
          8: (x) Don’t know
          9: (r) Refusal
    - id: C4
      kind: Question
      title: 'Who provides most of the help to ..... for his/her personal care? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (C2.outcome in [3, 8, 9])
        hint: Asked only when question C2 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
      input:
        control: Radio
        labels:
          1: (1) Mostly the mother
          2: (2) Mostly the father
          3: (3) Both the mother and the father
          4: (4) Other family members
          5: (5) Other, specify
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_mobility
    title: Help with moving about inside the residence
    items:
    - id: C5
      kind: Question
      title: Does ..... USUALLY receive help with moving about inside his/her residence, such as moving from one room to another?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: C6
      kind: Question
      title: Is this because of his/her condition or health problem?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: C7
      kind: Question
      title: 'How much help does he/she need? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Some help
          2: (2) A lot of help
          8: (x) Don’t know
          9: (r) Refusal
    - id: C8
      kind: Question
      title: 'Who provides most of the help to ..... for moving about inside his/her residence? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Mostly the mother
          2: (2) Mostly the father
          3: (3) Both the mother and the father
          4: (4) Other family members
          5: (5) Other, specify
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_current_need
    title: Help currently needed
    items:
    - id: C9_a
      kind: Question
      title: 'C9. Because of .....’s condition, do you CURRENTLY need help or additional help with: (a) his/her personal care?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C9_b
      kind: Question
      title: C9 (b) moving him/her about inside his/her residence?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C10
      kind: Question
      title: 'How many hours per week of help or additional help do you need? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) 1-4 hours per week
          2: (2) 5-10 hours per week
          3: (3) More than 10 hours per week
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_why_no_help
    title: Reasons for not receiving help
    items:
    - id: C11_a
      kind: Question
      title: C11. Why do you not receive this help? I will read you a list. Please answer yes or no to each. (a) It is too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_b
      kind: Question
      title: C11 (b) Help from family and friends is not available
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_c
      kind: Question
      title: C11 (c) Services or special programs (for help) are not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_d
      kind: Question
      title: C11 (d) Child is presently on a waiting list
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_e
      kind: Question
      title: C11 (e) Do not know where to look for help
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_f
      kind: Question
      title: C11 (f) Child’s condition is not serious enough
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_g
      kind: Question
      title: C11 (g) You have not asked for help
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C11_h
      kind: Question
      title: C11 (h) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_family_help
    title: Help received by the family
    items:
    - id: C12_a
      kind: Question
      title: 'C12. The next few questions are about the help YOU or YOUR FAMILY may be receiving because of .....’s condition or health problem. The help could be from family members, friends or from agencies or organizations. Because of .....’s condition, do you USUALLY receive help with the following: (a) help with everyday housework, such as house cleaning or meal preparation'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C12_b
      kind: Question
      title: C12 (b) help to allow you to attend to other family responsibilities
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C12_c
      kind: Question
      title: C12 (c) help to allow you to take time off for personal activities
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_a
      kind: Question
      title: C13. Who USUALLY provides you this help? I will read you a list. Please answer yes or no to each. (a) Family living with you
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_b
      kind: Question
      title: C13 (b) Family not living with you
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_c
      kind: Question
      title: C13 (c) Friends or neighbours
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_d
      kind: Question
      title: C13 (d) Government organization or agency
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_e
      kind: Question
      title: C13 (e) Private organization or agency
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_f
      kind: Question
      title: C13 (f) Voluntary organization or agency
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C13_g
      kind: Question
      title: C13 (g) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_expenses
    title: Out-of-pocket expenses for help
    items:
    - id: C14
      kind: Question
      title: You mentioned earlier that you usually receive help with everyday housework or help to allow you to attend to other family or personal activities. IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for this help?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
    - id: C15
      kind: Question
      title: 'What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program. $ .00 Range: 1-999999 (9999998 = (x) Don’t know, 9999999 = (r) Refusal)'
      input:
        control: Editbox
        min: 1
        max: 9999999
        left: $
    - id: C16
      kind: Question
      title: 'Which one of the following expense groups is the best estimate of the direct costs to you or your family? I will read you a list. Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Less than $200
          2: (2) $200 to less than $500
          3: (3) $500 to less than $1000
          4: (4) $1000 to less than $2000
          5: (5) $2000 to less than $5000
          6: (6) $5000 or more
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_additional_need
    title: Help currently needed by the family
    items:
    - id: C17_a
      kind: Question
      title: 'C17. Because of .....’s condition, do you CURRENTLY need help or additional help with the following: (a) help with everyday housework, such as house cleaning or meal preparation'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C17_b
      kind: Question
      title: C17 (b) help to allow you to attend to other family responsibilities
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C17_c
      kind: Question
      title: C17 (c) help to allow you to take time off for personal activities
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_why_no_additional_help
    title: Reasons for not receiving help or additional help
    precondition:
    - predicate: not (C17_a.outcome != 1 and C17_b.outcome != 1 and C17_c.outcome != 1)
      hint: Asked only when the respondent currently needs help with at least one item in C17.
    items:
    - id: C18_a
      kind: Question
      title: C18. Why do you not receive this help or additional help? I will read you a list. Please answer yes or no to each. (a) It is too expensive
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_b
      kind: Question
      title: C18 (b) Help from family and friends is not available
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_c
      kind: Question
      title: C18 (c) Services or special programs (for help) are not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_d
      kind: Question
      title: C18 (d) Child is presently on a waiting list
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_e
      kind: Question
      title: C18 (e) Do not know where to look for help
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_f
      kind: Question
      title: C18 (f) Child’s condition is not serious enough
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_g
      kind: Question
      title: C18 (g) You have not asked for help
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C18_h
      kind: Question
      title: C18 (h) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_care_coordination
    title: Coordination of care
    items:
    - id: C19
      kind: Question
      title: IN THE PAST 12 MONTHS, did you have any difficulty with coordinating the care of ....., for example, making appointments, phoning or visiting health professionals and specialists?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s6_coordination_difficulty
    title: Kinds of difficulty coordinating care
    precondition:
    - predicate: not (C19.outcome in [3, 8, 9])
      hint: Asked only when question C19 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: C20_a
      kind: Question
      title: C20. What kind of difficulty did you have? I will read you a list. Please answer yes or no to each. (a) Difficulty obtaining appointments
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_b
      kind: Question
      title: C20 (b) Health professional or specialist not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_c
      kind: Question
      title: C20 (c) A lack of communication between health professionals
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_d
      kind: Question
      title: C20 (d) Difficulty getting information
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_e
      kind: Question
      title: C20 (e) Your lack of time to coordinate the care
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_f
      kind: Question
      title: C20 (f) Work conflicts
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C20_g
      kind: Question
      title: C20 (g) Other difficulty, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
  - id: b_s6_work_financial_impact
    title: Work and financial impact on the family
    items:
    - id: C21
      kind: Question
      title: 'Who USUALLY coordinates the care of .....? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Mostly the mother
          2: (2) Mostly the father
          3: (3) Both the father and the mother
          4: (4) Other family members
          5: (5) Other, specify
          8: (x) Don’t know
          9: (r) Refusal
    - id: C22_a
      kind: Question
      title: 'C22. Because of .....’s condition or health problem, has anyone in your family EVER: (a) not taken a job in order to take care of the child?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C22_b
      kind: Question
      title: C22 (b) quit working (other than normal maternity or paternity leave)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C22_c
      kind: Question
      title: C22 (c) changed work hours to different time of day (or night)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C22_d
      kind: Question
      title: C22 (d) turned down a promotion or a better job?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C22_e
      kind: Question
      title: C22 (e) worked fewer hours?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) DK
          9: (r) Ref
    - id: C23
      kind: Question
      title: 'Who was most affected by these work-related issues? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (C22_a.outcome != 1 and C22_b.outcome != 1 and C22_c.outcome != 1 and C22_d.outcome != 1 and C22_e.outcome != 1)
        hint: Asked only when at least one work-related effect in C22 was reported.
      input:
        control: Radio
        labels:
          1: (1) Mostly the mother
          2: (2) Mostly the father
          3: (3) Both the mother and the father
          4: (4) Other family members
          5: (5) Other, specify
          8: (x) Don’t know
          9: (r) Refusal
    - id: C24
      kind: Question
      title: DURING THE PAST 12 MONTHS, has your family had financial problems because of .....’s condition or health problem?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s7_child_care
    title: SECTION D — CHILD CARE
    items:
    - id: D1
      kind: Question
      title: Now, I’d like to ask you some questions about child care arrangements for ..... . Do you CURRENTLY use child care such as day care, babysitting or a before and after school program for ..... while you (or your spouse/partner) are at work or studying?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refusal
  - id: b_s8_care_arrangements
    title: Child care (continued)
    precondition:
    - predicate: not (D1.outcome in [3, 8, 9])
      hint: Asked only when question D1 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: D2
      kind: Question
      title: 'What is your MAIN child care arrangement for ..... ? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Before and after school program
          2: (2) Nursery school
          3: (3) Day care centre
          4: (4) Care in someone else’s home by a non-relative
          5: (5) Care in someone else’s home by a relative
          6: (6) Care in child’s home by a non-relative
          7: (7) Care in child’s home by a relative
          8: (8) Other, specify
          98: (x) Don’t know
          99: (r) Refusal
    - id: D3
      kind: Question
      title: 'Approximately how many hours per WEEK is that? Interviewer: This is for the MAIN child care arrangement only. Hours per WEEK Interviewer: Round to the nearest full hour.'
      input:
        control: Editbox
        min: 0
        max: 99
        right: hours per week (98 = Don’t know, 99 = Refusal)
    - id: D4
      kind: Question
      title: Do you use any other child care arrangement for ..... ?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D5
      kind: Question
      title: 'Approximately how many hours per WEEK is that? Hours per WEEK Interviewer: Round to the nearest full hour.'
      precondition:
      - predicate: not (D4.outcome in [3, 98, 99])
        hint: Asked only when question D4 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
      postcondition:
      - predicate: D4.outcome != 1 or D3.outcome >= 98 or D5.outcome >= 98 or D3.outcome + D5.outcome <= 168
        hint: Hours per week in D3 (main arrangement) and D5 (other arrangement) together cannot exceed 168, the number of hours in a week.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: hours per week (98 = Don’t know, 99 = Refusal)
  - id: b_s8_refusals
    title: Refusals by child care programs
    items:
    - id: D6
      kind: Question
      title: Has a child care program or service ever refused to take care of ..... because of his/her condition or health problem?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7a
      kind: Question
      title: 'D7. What type of child care programs or services refused to provide care to ..... ? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Before and after school program'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7b
      kind: Question
      title: D7. (b) Nursery school
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7c
      kind: Question
      title: D7. (c) Day care centre
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7d
      kind: Question
      title: D7. (d) Care in someone else’s home
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7e
      kind: Question
      title: D7. (e) Care in child’s home
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: D7f
      kind: Question
      title: D7. (f) Other, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_preamble
    title: Section E setup
    items:
    - id: BORN_AFTER_MAY_15_1996
      kind: Question
      title: 'External input: whether the child was born AFTER May 15, 1996 (Interviewer: This section is NOT asked if child was born AFTER May 15,1996. If child was born AFTER May 15,1996, go to I1 (page 50). Otherwise, go to E1.)'
      external: true
      input:
        control: Radio
        labels:
          1: Yes, born after May 15, 1996
          3: No, born on or before May 15, 1996
  - id: b_s9_p1_e1
    title: Education in April 2001
    items:
    - id: E1
      kind: Question
      title: 'The next few questions are about education. In APRIL 2001 was ..... : Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) going to school or kindergarten
          2: (2) being tutored at home through the school system
          3: (3) neither of the above (i.e. neither going to school or being tutored at home)
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_not_school
    title: Not attending school
    precondition:
    - predicate: not (E1.outcome == 1)
      hint: Asked only when question E1 is not "(1) going to school or kindergarten".
    items:
    - id: E2a
      kind: Question
      title: 'E2. Why was ..... being tutored at home through the school system? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Personal care such as feeding and toiletting needed, but not available at school'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E2b
      kind: Question
      title: E2. (b) Teacher’s aides or special education classes not available in REGULAR SCHOOL
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E2c
      kind: Question
      title: E2. (c) SPECIAL EDUCATION SCHOOL not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E2d
      kind: Question
      title: E2. (d) Child’s condition or health problem prevented him/her from going to school
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E2e
      kind: Question
      title: E2. (e) Parents preferred home tutoring for the child
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E2f
      kind: Question
      title: E2. (f) Other reason, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3a
      kind: Question
      title: 'E3. Why was ..... not attending school in April 2001? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Personal care such as feeding and toiletting needed, but not available at school'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3b
      kind: Question
      title: E3. (b) Teacher’s aides or special education classes not available in REGULAR SCHOOL
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3c
      kind: Question
      title: E3. (c) SPECIAL EDUCATION SCHOOL not available locally
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3d
      kind: Question
      title: E3. (d) Child’s condition or health problem prevented him/her from going to school
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3e
      kind: Question
      title: E3. (e) Child not ready or too young to attend school
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E3f
      kind: Question
      title: E3. (f) Other reason, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E4
      kind: Question
      title: Did ..... ever go to school?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_never_attended
    title: Never attended school
    precondition:
    - predicate: not (E1.outcome == 1)
      hint: Asked only when question E1 is not "(1) going to school or kindergarten".
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E5
      kind: Question
      title: 'Why did ..... never attend school? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Personal care such as feeding and toiletting needed, but not available at school
          2: (b) Teacher’s aides or special education classes not available in REGULAR SCHOOL
          4: (c) SPECIAL EDUCATION SCHOOL not available locally
          8: (d) Child’s condition or health problem prevented him/her from going to school
          16: (e) Child not ready or too young to attend school
          32: (f) Other reason, specify
          64: (x) Don’t know
          128: (r) Refusal
  - id: b_s9_p1_school_type
    title: Type of school and classes
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E6
      kind: Question
      title: 'In APRIL 2001, what type of school was ..... attending? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Special education school
          2: (2) Regular school
          3: (3) Regular school with special education classes
          4: (4) Other, specify
          98: (x) Don’t know
          99: (r) Refusal
    - id: E7
      kind: Question
      title: 'At this school, what type of classes was ..... attending? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (E6.outcome == 99)
        hint: Asked only when question E6 is not "(r) Refusal".
      input:
        control: Radio
        labels:
          1: (1) Only regular classes
          2: (2) Some regular classes and some special education classes
          3: (3) Only special education classes
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_special_ed
    title: Special education
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    - predicate: not (E7.outcome == 1)
      hint: Asked only when question E7 is not "(1) Only regular classes".
    items:
    - id: E8
      kind: Question
      title: Did ..... ever attend a special education school?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E9
      kind: Question
      title: 'Why didn’t he/she attend a special education school in April 2001? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Special education school no longer available locally
          2: (b) Child has moved into regular school
          4: (c) Other reason, specify
          8: (x) Don’t know
          16: (r) Refusal
    - id: E10a
      kind: Question
      title: 'E10. What is the MAIN condition or health problem which required ..... to receive special education services? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Learning disabilities'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10b
      kind: Question
      title: E10. (b) Developmental disability or disorder
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10c
      kind: Question
      title: E10. (c) Speech or language difficulties
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10d
      kind: Question
      title: E10. (d) Emotional, psychological or behavioural conditions
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10e
      kind: Question
      title: E10. (e) Hearing difficulties, including deafness
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10f
      kind: Question
      title: E10. (f) Vision difficulties, including blindness
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10g
      kind: Question
      title: E10. (g) Difficulty with walking or moving around
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E10h
      kind: Question
      title: E10. (h) Other condition, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_e11
    title: Difficulty getting special education services
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E11
      kind: Question
      title: Did you ever have any difficulty in trying to get special education services for ..... ?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_e12
    title: Kind of difficulty
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    - predicate: not (E11.outcome in [3, 98, 99])
      hint: Asked only when question E11 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: E12a
      kind: Question
      title: 'E12. What kind of difficulty did you have? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Special education services not available locally'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E12b
      kind: Question
      title: E12. (b) Insufficient level of staffing or special education services
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E12c
      kind: Question
      title: E12. (c) Communication problems with school
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E12d
      kind: Question
      title: E12. (d) Difficulty to have the child tested for special education services
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E12e
      kind: Question
      title: E12. (e) Other difficulty, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_province_grade
    title: Province and grade
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E13
      kind: Question
      title: 'In APRIL 2001, in which province or territory did ..... attend school? Interviewer: Do NOT read list. Mark one only.'
      input:
        control: Dropdown
        labels:
          1: (01) Newfoundland
          2: (02) Prince Edward Island
          3: (03) Nova Scotia
          4: (04) New Brunswick
          5: (05) Quebec
          6: (06) Ontario
          7: (07) Manitoba
          8: (08) Saskatchewan
          9: (09) Alberta
          10: (10) British Columbia
          11: (11) Northwest Territory
          12: (12) Nunavut
          13: (13) Yukon
          14: (14) Other, specify
          98: (x) Don’t Know
          99: (r) Refusal
    - id: E14
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? (Newfoundland) Interviewer: Do NOT read list. Mark one only.'
      precondition:
      - predicate: not (E13.outcome == 2)
        hint: Asked only when question E13 is not "(02) Prince Edward Island".
      - predicate: not (E13.outcome == 3)
        hint: Asked only when question E13 is not "(03) Nova Scotia".
      - predicate: not (E13.outcome == 4)
        hint: Asked only when question E13 is not "(04) New Brunswick".
      - predicate: not (E13.outcome == 5)
        hint: Asked only when question E13 is not "(05) Quebec".
      - predicate: not (E13.outcome == 6)
        hint: Asked only when question E13 is not "(06) Ontario".
      - predicate: not (E13.outcome in [7, 8, 9, 10, 11, 12, 13, 14, 98, 99])
        hint: Asked only when question E13 is none of "(07) Manitoba", "(08) Saskatchewan", "(09) Alberta", "(10) British Columbia", "(11) Northwest Territory", "(12) Nunavut", "(13) Yukon", "(14) Other, specify", "(x) Don’t Know", "(r) Refusal".
      input:
        control: Dropdown
        labels:
          1: (01) Kindergarten
          2: (02) Grade 1 Elementary
          3: (03) Grade 2 Elementary
          4: (04) Grade 3 Elementary
          5: (05) Grade 4 Elementary
          6: (06) Grade 5 Elementary
          7: (07) Grade 6 Elementary
          8: (08) Grade 7
          9: (09) Grade 8
          10: (10) Grade 9
          11: (11) Level 1 Secondary
          12: (12) Level 2 Secondary
          13: (13) Level 3 Secondary
          14: (14) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
    - id: E15
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? (Prince Edward Island) Interviewer: Do NOT read list. Mark one only.'
      precondition:
      - predicate: not (E13.outcome == 3)
        hint: Asked only when question E13 is not "(03) Nova Scotia".
      - predicate: not (E13.outcome == 4)
        hint: Asked only when question E13 is not "(04) New Brunswick".
      - predicate: not (E13.outcome == 5)
        hint: Asked only when question E13 is not "(05) Quebec".
      - predicate: not (E13.outcome == 6)
        hint: Asked only when question E13 is not "(06) Ontario".
      - predicate: not (E13.outcome in [7, 8, 9, 10, 11, 12, 13, 14, 98, 99])
        hint: Asked only when question E13 is none of "(07) Manitoba", "(08) Saskatchewan", "(09) Alberta", "(10) British Columbia", "(11) Northwest Territory", "(12) Nunavut", "(13) Yukon", "(14) Other, specify", "(x) Don’t Know", "(r) Refusal".
      - predicate: not (E14.outcome in [98, 99])
        hint: Asked only when question E14 is none of "(x) Don’t know", "(r) Refusal".
      input:
        control: Dropdown
        labels:
          1: (01) Grade 1
          2: (02) Grade 2
          3: (03) Grade 3
          4: (04) Grade 4
          5: (05) Grade 5
          6: (06) Grade 6
          7: (07) Grade 7
          8: (08) Grade 8
          9: (09) Grade 9
          10: (10) Grade 10
          11: (11) Grade 11
          12: (12) Grade 12
          13: (13) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
    - id: E16
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? (Nova Scotia) Interviewer: Do NOT read list. Mark one only.'
      precondition:
      - predicate: not (E13.outcome == 4)
        hint: Asked only when question E13 is not "(04) New Brunswick".
      - predicate: not (E13.outcome == 5)
        hint: Asked only when question E13 is not "(05) Quebec".
      - predicate: not (E13.outcome == 6)
        hint: Asked only when question E13 is not "(06) Ontario".
      - predicate: not (E13.outcome in [7, 8, 9, 10, 11, 12, 13, 14, 98, 99])
        hint: Asked only when question E13 is none of "(07) Manitoba", "(08) Saskatchewan", "(09) Alberta", "(10) British Columbia", "(11) Northwest Territory", "(12) Nunavut", "(13) Yukon", "(14) Other, specify", "(x) Don’t Know", "(r) Refusal".
      - predicate: not (E14.outcome in [98, 99])
        hint: Asked only when question E14 is none of "(x) Don’t know", "(r) Refusal".
      input:
        control: Dropdown
        labels:
          1: (01) Primary
          2: (02) Grade 1
          3: (03) Grade 2
          4: (04) Grade 3
          5: (05) Grade 4
          6: (06) Grade 5
          7: (07) Grade 6
          8: (08) Grade 7
          9: (09) Grade 8
          10: (10) Grade 9
          11: (11) Grade 10
          12: (12) Grade 11
          13: (13) Grade 12
          14: (14) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
    - id: E17
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? (Quebec) Interviewer: Do NOT read list. Mark one only.'
      precondition:
      - predicate: not (E13.outcome == 4)
        hint: Asked only when question E13 is not "(04) New Brunswick".
      - predicate: not (E13.outcome == 6)
        hint: Asked only when question E13 is not "(06) Ontario".
      - predicate: not (E13.outcome in [7, 8, 9, 10, 11, 12, 13, 14, 98, 99])
        hint: Asked only when question E13 is none of "(07) Manitoba", "(08) Saskatchewan", "(09) Alberta", "(10) British Columbia", "(11) Northwest Territory", "(12) Nunavut", "(13) Yukon", "(14) Other, specify", "(x) Don’t Know", "(r) Refusal".
      - predicate: not (E14.outcome in [98, 99])
        hint: Asked only when question E14 is none of "(x) Don’t know", "(r) Refusal".
      input:
        control: Dropdown
        labels:
          1: (01) Junior Kindergarten
          2: (02) Kindergarten
          3: (03) Grade 1 Elementary
          4: (04) Grade 2 Elementary
          5: (05) Grade 3 Elementary
          6: (06) Grade 4 Elementary
          7: (07) Grade 5 Elementary
          8: (08) Grade 6 Elementary
          9: (09) Secondary I
          10: (10) Secondary II
          11: (11) Secondary III
          12: (12) Secondary IV
          13: (13) Secondary V
          14: (14) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
    - id: E18
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? (Ontario) Interviewer: Do NOT read list. Mark one only.'
      precondition:
      - predicate: not (E13.outcome == 4)
        hint: Asked only when question E13 is not "(04) New Brunswick".
      - predicate: not (E13.outcome in [7, 8, 9, 10, 11, 12, 13, 14, 98, 99])
        hint: Asked only when question E13 is none of "(07) Manitoba", "(08) Saskatchewan", "(09) Alberta", "(10) British Columbia", "(11) Northwest Territory", "(12) Nunavut", "(13) Yukon", "(14) Other, specify", "(x) Don’t Know", "(r) Refusal".
      - predicate: not (E14.outcome in [98, 99])
        hint: Asked only when question E14 is none of "(x) Don’t know", "(r) Refusal".
      input:
        control: Dropdown
        labels:
          1: (01) Junior Kindergarten
          2: (02) Kindergarten
          3: (03) Grade 1
          4: (04) Grade 2
          5: (05) Grade 3
          6: (06) Grade 4
          7: (07) Grade 5
          8: (08) Grade 6
          9: (09) Grade 7
          10: (10) Grade 8
          11: (11) Grade 9
          12: (12) Grade 10
          13: (13) Grade 11
          14: (14) Grade 12
          15: (15) OAC Grade 13
          16: (16) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
    - id: E19
      kind: Question
      title: 'In what grade was ..... enrolled in APRIL 2001? Interviewer: Do NOT read list. Mark one only.'
      input:
        control: Dropdown
        labels:
          1: (01) Kindergarten
          2: (02) Grade 1
          3: (03) Grade 2
          4: (04) Grade 3
          5: (05) Grade 4
          6: (06) Grade 5
          7: (07) Grade 6
          8: (08) Grade 7
          9: (09) Grade 8
          10: (10) Grade 9
          11: (11) Grade 10
          12: (12) Grade 11
          13: (13) Grade 12
          14: (14) Ungraded
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_school_services
    title: Education, training, therapy and last school year
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E20a
      kind: Question
      title: 'E20. In APRIL 2001, what type of education, training or therapy was ..... receiving at school? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Academic subjects'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E20b
      kind: Question
      title: E20. (b) Life skills
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E20c
      kind: Question
      title: E20. (c) Speech and language therapy
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E20d
      kind: Question
      title: E20. (d) Mental health or counselling services
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E21
      kind: Question
      title: 'The next few questions are about the last school year, that is to say, the one which finished in June 2001. Based on your knowledge of his/her school work, including his/her report cards, how did ..... do during the last school year? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Very well
          2: (2) Well
          3: (3) Average
          4: (4) Poorly
          5: (5) Very poorly
          6: (6) Not applicable
          98: (x) Don’t know
          99: (r) Refusal
    - id: E22
      kind: Question
      title: 'How often did you (or your spouse/partner) check .....’s homework or provide help with his/her homework during the last school year? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: (1) Never or rarely
          2: (2) Less than once a month
          3: (3) At least once a month
          4: (4) At least once a week
          5: (5) A few times a week
          6: (6) Every day
          98: (x) Don’t know
          99: (r) Refusal
    - id: E23a
      kind: Question
      title: 'E23. Because of a condition or health problem: Interviewer: Read list. (a) did .....have to leave his/her community to attend school?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E23b
      kind: Question
      title: E23. (b) was his/her schooling interrupted for long periods of time?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E23c
      kind: Question
      title: E23. (c) did .....take fewer courses or academic subjects at school?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E23d
      kind: Question
      title: E23. (d) did it take .....longer to achieve his/her present level of education?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E24a
      kind: Question
      title: 'E24. Did a condition or health problem limit .....’s participation in any of the following SCHOOL ACTIVITIES during the last school year (which ended in June 2001)? Interviewer: Read list. (a) Taking part in physical education or organized games requiring physical activity'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E24b
      kind: Question
      title: E24. (b) Playing with others during recess or lunch hour
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E24c
      kind: Question
      title: E24. (c) Taking part in school outings, such as visits to a museum
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E24d
      kind: Question
      title: E24. (d) Classroom participation
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E25
      kind: Question
      title: Please remember the questions are about the last school year, that is to say, the one which finished in June 2001. Because of a condition or health problem, did ..... USE any special building features or equipment, such as ramps or automatic door openers AT SCHOOL?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p1_school_features
    title: Special features used at school
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    - predicate: not (E25.outcome in [3, 98, 99])
      hint: Asked only when question E25 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: E26a
      kind: Question
      title: 'E26. Which kind of special features did he/she USE at school? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Ramps or street level entrances'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p2_e26
    title: School accessibility features available
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    - predicate: not (E25.outcome in [3, 98, 99])
      hint: Asked only when question E25 is none of "(3) No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: E26b
      kind: Question
      title: E26. (b) Widened doorways or hallways
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E26c
      kind: Question
      title: E26. (c) Automatic or easy to open doors
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E26d
      kind: Question
      title: E26. (d) An elevator or lift device
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E26e
      kind: Question
      title: E26. (e) Special railings in washrooms
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E26f
      kind: Question
      title: E26. (f) Other feature, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s9_p2_e27_e30
    title: School features, aids and services needed
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E27
      kind: Question
      title: Because of a condition or a health problem, did ..... NEED any special features or equipment, such as ramps or automatic door openers AT SCHOOL, which were not available?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E28
      kind: Question
      title: 'What kind of special features or equipment did he/she need AT SCHOOL, but did not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Ramps or street level entrances
          2: (b) Widened doorways or hallways
          4: (c) Automatic or easy to open doors
          8: (d) An elevator or lift device
          16: (e) Special railings in washrooms
          32: (f) Other feature, specify
          64: (x) Don’t know
          128: (r) Refusal
    - id: E29a
      kind: Question
      title: 'E29. During the last school year, did ..... USE any assistive aids, devices or services AT SCHOOL? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Tutors or teacher’s aides'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29b
      kind: Question
      title: E29. (b) Note takers or readers
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29c
      kind: Question
      title: E29. (c) Sign language interpreters
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29d
      kind: Question
      title: E29. (d) Attendant care services
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29e
      kind: Question
      title: E29. (e) Amplifiers, such as FM or infrared
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29f
      kind: Question
      title: E29. (f) Talking books
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29g
      kind: Question
      title: E29. (g) Magnifiers
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29h
      kind: Question
      title: E29. (h) Recording equipment
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29i
      kind: Question
      title: E29. (i) A computer with Braille or speech access
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E29j
      kind: Question
      title: E29. (j) Other aid or service, specify
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
    - id: E30
      kind: Question
      title: Were there any assistive aids, devices or services that ..... needed AT SCHOOL, but did not have?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s10_preamble
    title: Interview setup
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: BORN_AFTER_1996_05_15_2
      kind: Question
      title: 'External input: whether the child was born AFTER May 15, 1996 (from the sample file / child''s date of birth). Sections F, G and H are NOT asked if so.'
      external: true
      input:
        control: Radio
        labels:
          1: Yes, born after May 15, 1996
          3: 'No'
  - id: b_s10_school_experience
    title: Aids, parental involvement, school experience and transportation
    precondition:
    - predicate: not (E4.outcome == 1)
      hint: Asked only when question E4 is not "(1) Yes".
    items:
    - id: E31
      kind: Question
      title: 'What kind of assistive aids or services did he/she need AT SCHOOL, but did not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Tutors or teacher’s aides
          2: (b) Note takers or readers
          4: (c) Sign language interpreters
          8: (d) Attendant care services
          16: (e) Amplifiers, such as FM or infrared
          32: (f) Talking books
          64: (g) Magnifiers
          128: (h) Recording equipment
          256: (i) A computer with Braille or speech access
          512: (j) Other aid or service, specify
          1024: (x) Don’t know
          2048: (r) Refusal
    - id: E32a
      kind: Question
      title: 'Why didn’t ..... have these aids or services AT SCHOOL? (a) School funding cutbacks or lack of funding in the school system. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E32b
      kind: Question
      title: (b) School did not think child needed assistive aids or services.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E32c
      kind: Question
      title: (c) Child did not want to use assistive aids or services.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E32d
      kind: Question
      title: (d) Other reason, specify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33a
      kind: Question
      title: 'During the last school year, have you (or your partner/spouse) done any of the following for ..... ? (a) Spoken to, visited or corresponded with child’s teacher. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33b
      kind: Question
      title: (b) Attended a school event in which child participated, for example, a play, sports competition, or science fair.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33c
      kind: Question
      title: (c) Volunteered in child’s class or helped with a class trip.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33d
      kind: Question
      title: (d) Helped elsewhere in the school, such as in the library or computer room.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33e
      kind: Question
      title: (e) Attended a parent-school association, parent advisory committee or parent council meeting.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33f
      kind: Question
      title: (f) Fundraising for school.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E33g
      kind: Question
      title: (g) Other activity, specify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E34a
      kind: Question
      title: 'Do you strongly agree, agree, disagree, or strongly disagree with the following descriptions of the school that ..... attended during the last school year? (a) The school offered parents many opportunities to be involved in the school activities. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
          7: DK
          9: Ref
    - id: E34b
      kind: Question
      title: (b) Parents were made to feel welcome in the school.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
          7: DK
          9: Ref
    - id: E34c
      kind: Question
      title: (c) Overall, the school accommodated the child’s condition or health problem.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
          7: DK
          9: Ref
    - id: E35
      kind: Question
      title: 'With regard to how he/she feels about school, how often did ..... look forward to going to school during the last school year? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Almost never
          2: Rarely
          3: Sometimes
          4: Often
          5: Almost always
          7: Don’t know
          9: Refusal
    - id: E36
      kind: Question
      title: 'During the last school year, what was the method of transportation ..... used MOST OFTEN to get to school? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Was driven to school by family motor vehicle
          2: School bus
          3: Regular city bus
          4: Specialized bus services for persons with disabilities
          5: Walked or biked to school
          6: Other, specify
          7: Don’t know
          9: Refusal
  - id: b_s10_assessment
    title: Professional assessment
    items:
    - id: E37
      kind: Question
      title: Has a professional assessment ever been done to determine .....’s educational needs?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
    - id: E38a
      kind: Question
      title: 'Who completed this assessment? (a) Psychologist or psychiatrist. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E38b
      kind: Question
      title: (b) Social worker.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E38c
      kind: Question
      title: (c) Special education consultant.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E38d
      kind: Question
      title: (d) Speech or language therapist.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: E38e
      kind: Question
      title: (e) Other professional or specialist, specify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s11_leisure
    title: SECTION F — LEISURE AND RECREATION ACTIVITIES
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: F1a
      kind: Question
      title: 'The next few questions are about .....’s interests and activities. In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she: (a) taken part in sports with a coach or instructor (except dance or gymnastics)? Interviewer: Read categories. Mark one only.'
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F1a_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F1a)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F1b
      kind: Question
      title: (b) taken lessons or instruction in other organized physical activities with a coach or instructor, such as dance, gymnastics or martial arts?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F1b_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F1b)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F1c
      kind: Question
      title: (c) taken part in unorganized sports or physical activities without a coach or instructor?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F1c_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F1c)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F1d
      kind: Question
      title: (d) taken lessons or instruction in music, art or other non-sport activities?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F1d_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F1d)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F1e
      kind: Question
      title: (e) taken part in clubs, groups or community programs, such as church groups, Girl or Boy Scouts?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F1e_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F1e)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F2a
      kind: Question
      title: 'How often does he/she: (a) watch T.V.? Interviewer: Read categories. Mark one only.'
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F2a_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F2a)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F2b
      kind: Question
      title: (b) play computer or video games
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F2b_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F2b)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F2c
      kind: Question
      title: (c) talk on the phone with friends
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F2c_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F2c)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F3
      kind: Question
      title: 'How often does ..... read or have books read to him/her (for pleasure)? Please do not include reading that is required for school. Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Everyday
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: Don’t know
          9: Refusal
    - id: F3_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (asked under F3 option 1, Everyday)'
      precondition:
      - predicate: F3.outcome == 1
        hint: Asked only when F3 is "Everyday".
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F4
      kind: Question
      title: 'Outside of school hours, how often does he/she play alone, for example, riding a bike or doing a craft? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Seldom
          4: Never
          7: Don’t know
          9: Refusal
    - id: F5
      kind: Question
      title: Has ..... ever gone to summer camps (including regular or special camps)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
    - id: F6
      kind: Question
      title: Was this a camp for children with a health problem or condition?
      precondition:
      - predicate: not (F5.outcome in [3, 7, 9])
        hint: Asked only when question F5 is none of "No", "Don’t know", "Refusal".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
    - id: F7
      kind: Question
      title: Because of a condition or health problem, is ..... prevented from taking part in any social or physical leisure activities?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s11_barriers
    title: What prevents more leisure activities
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (F7.outcome in [3, 7, 9])
      hint: Asked only when question F7 is none of "No", "Don’t know", "Refusal".
    items:
    - id: F8a
      kind: Question
      title: 'What prevents ..... from doing more social or physical leisure activities? (a) Recreational facilities or programs not available locally. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8b
      kind: Question
      title: (b) Buildings and equipment not physically accessible.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8c
      kind: Question
      title: (c) Inadequate transportation services
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8d
      kind: Question
      title: (d) Too expensive
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8e
      kind: Question
      title: (e) Child is physically unable to do more.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8f
      kind: Question
      title: (f) Child needs someone’s assistance
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8g
      kind: Question
      title: (g) Child needs specialized aids or equipment, but he/she doesn’t have them.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: F8h
      kind: Question
      title: (h) Other reason, specify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s11_peers_computer
    title: Getting along with other children; personal computers
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: F9
      kind: Question
      title: 'DURING THE PAST SIX MONTHS, how well has ..... gotten along with other children, such as friends or classmates (excluding brothers or sisters)? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Very well (or no problems)
          2: Quite well (or hardly any problems)
          3: Pretty well (or occasional problems)
          4: Not too well (or frequent problems)
          5: Not well at all (or constant problems)
          7: Don’t know
          9: Refusal
    - id: F10
      kind: Question
      title: 'The next few questions deal with the use of the computer and the Internet. How many personal computers are there in your home? Interviewer: Do NOT read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: None
          2: One
          3: Two
          4: Three or more
          7: Don’t know
          9: Refusal
  - id: b_s11_internet_home
    title: Computer and Internet at home
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (F10.outcome in [7, 9])
      hint: Asked only when question F10 is none of "Don’t know", "Refusal".
    items:
    - id: F11
      kind: Question
      title: 'What are the reasons that keep you from purchasing a personal computer? Interviewer: Do NOT read list. Mark all that apply.'
      precondition:
      - predicate: not (F10.outcome in [2, 3, 4])
        hint: Asked only when question F10 is none of "One", "Two", "Three or more".
      input:
        control: Checkbox
        labels:
          1: (a) Cost
          2: (b) Not needed at home
          4: (c) Not interested
          8: (d) Lack of computer skills or training
          16: (e) Fear of technology
          32: (f) Disability
          64: (g) Other, specify
          128: (x) Don’t know
          256: (r) Refusal
    - id: F12
      kind: Question
      title: Is your household connected to the Internet?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
    - id: F13
      kind: Question
      title: 'What are the reasons that keep you from getting Internet access for your HOME? Interviewer: Do NOT read list. Mark all that apply.'
      precondition:
      - predicate: not (F12.outcome == 1)
        hint: Asked only when question F12 is not "Yes".
      input:
        control: Checkbox
        labels:
          1: (a) Cost
          2: (b) Not needed at home
          4: (c) Not interested
          8: (d) Lack of computer skills or training
          16: (e) Fear of technology
          32: (f) Disability
          64: (g) Other, specify
          128: (x) Don’t know
          256: (r) Refusal
    - id: F14
      kind: Question
      title: Does ..... use the Internet AT HOME?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s11_internet_use
    title: Child's Internet use at home
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (F10.outcome in [7, 9])
      hint: Asked only when question F10 is none of "Don’t know", "Refusal".
    - predicate: not (F14.outcome in [7, 9])
      hint: Asked only when question F14 is none of "Don’t know", "Refusal".
    items:
    - id: F15
      kind: Question
      title: 'What are the reasons that keep ..... from using the Internet at home? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Child too young or not ready to use it
          2: (b) Child does not need it
          4: (c) Child is not interested
          8: (d) Child does not have the computer skills or training
          16: (e) Child’s condition or health problem
          32: (f) Other, specify
          64: (x) Don’t know
          128: (r) Refusal
    - id: F16a
      kind: Question
      title: 'AT HOME, how often does he/she use: (a) Internet to participate in newsgroups or chat groups? Interviewer: Read categories. Mark one only.'
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F16a_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F16a)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F16b
      kind: Question
      title: (b) Internet for school work?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F16b_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F16b)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F16c
      kind: Question
      title: (c) Internet for personal interest or entertainment?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F16c_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F16c)'
      input:
        control: Editbox
        min: 0
        max: 24
    - id: F16d
      kind: Question
      title: (d) E-mail to stay in touch with friends?
      input:
        control: Radio
        labels:
          1: Every-day
          2: At least once a week
          3: At least once a month
          4: Less than once a month
          5: Never
          7: DK
          9: Ref
    - id: F16d_hours
      kind: Question
      title: 'How many hours a day? Interviewer: Round to the nearest full hour. (F16d)'
      input:
        control: Editbox
        min: 0
        max: 24
  - id: b_s12_g1
    title: G1 Special features to enter or leave
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: G1
      kind: Question
      title: Because of a condition or health problem, does ..... USE any special features, such as access ramps or automatic door openers to ENTER or LEAVE his/her residence?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s12_g2
    title: G2 Which special features used to enter or leave
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G1.outcome in [3, 7, 9])
      hint: Asked only when question G1 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G2a
      kind: Question
      title: 'Which special features does he/she use? (a) Ramps or street level entrances. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G2b
      kind: Question
      title: (b) Widened doorways or hallways.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G2c
      kind: Question
      title: (c) Automatic or easy to open doors.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G2d
      kind: Question
      title: (d) An elevator or lift device
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G2e
      kind: Question
      title: (e) Other feature, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s12_g3
    title: G3 Needed features to enter or leave
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: G3
      kind: Question
      title: Does ..... CURRENTLY need any special features to enter or leave his/her residence, which he/she does not have?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s12_g4
    title: G4 Which features needed to enter or leave
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G3.outcome in [3, 7, 9])
      hint: Asked only when question G3 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G4
      kind: Question
      title: 'Which special features does ..... NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Ramps or street level entrances
          2: (b) Widened doorways or hallways
          4: (c) Automatic or easy to open doors
          8: (d) An elevator or lift device
          16: (e) Other feature, specify
          32: (x) Don’t know
          64: (r) Refusal
  - id: b_s12_g5
    title: G5 Why features to enter or leave are missing
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G3.outcome in [3, 7, 9])
      hint: Asked only when question G3 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G5a
      kind: Question
      title: 'Why doesn’t ..... have these special features that he/she needs to enter or leave his/her residence? (a) Not covered by insurance. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G5b
      kind: Question
      title: (b) Too expensive.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G5c
      kind: Question
      title: (c) Landlord/landlady not willing.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G5d
      kind: Question
      title: (d) Only needed occasionally.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G5e
      kind: Question
      title: (e) Other reason, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s12_g6
    title: G6 Special features used inside
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: G6
      kind: Question
      title: Because of a condition or health problem, does ..... USE any special features, such as special railings, grab bars or lift devices INSIDE his/her residence?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s12_g7
    title: G7 Which special features used inside
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G6.outcome in [3, 7, 9])
      hint: Asked only when question G6 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G7a
      kind: Question
      title: 'Which special features does ..... use INSIDE his/her residence? (a) Grab bars or bath lift device in the bathroom. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7b
      kind: Question
      title: (b) Lowered counters, sinks or switches in the kitchen.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7c
      kind: Question
      title: (c) An elevator or lift device.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7d
      kind: Question
      title: (d) Widened doorways or hallways
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7e
      kind: Question
      title: (e) Automatic or easy to open doors
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7f
      kind: Question
      title: (f) Visual or flashing alarms
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7g
      kind: Question
      title: (g) Audio warning devices.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G7h
      kind: Question
      title: (h) Other feature, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s12_g8
    title: G8 Needed features inside
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: G8
      kind: Question
      title: Does ..... CURRENTLY need any special features INSIDE his/her residence, which he/she does not have?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s12_g9
    title: G9 Which features needed inside
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G8.outcome in [3, 7, 9])
      hint: Asked only when question G8 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G9
      kind: Question
      title: 'Which special features does ..... NEED, but does not have? Interviewer: Do NOT read list. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (a) Grab bars or bath lift device in the bathroom
          2: (b) Lowered counters, sinks or switches in the kitchen
          4: (c) An elevator or lift device
          8: (d) Widened doorways or hallways
          16: (e) Automatic or easy to open doors
          32: (f) Visual or flashing alarms
          64: (g) Audio warning devices
          128: (h) Other feature, specify
          256: (x) Don’t know
          512: (r) Refusal
  - id: b_s12_g10
    title: G10 Why features inside are missing
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    - predicate: not (G8.outcome in [3, 7, 9])
      hint: Asked only when question G8 is none of "No", "Don’t know", "Refusal".
    items:
    - id: G10a
      kind: Question
      title: 'Why doesn’t ..... have these special features INSIDE his/her residence? (a) Not covered by insurance. Interviewer: Read list.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G10b
      kind: Question
      title: (b) Too expensive.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G10c
      kind: Question
      title: (c) Landlord/landlady not willing.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G10d
      kind: Question
      title: (d) Only needed occasionally.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
    - id: G10e
      kind: Question
      title: (e) Other reason, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: DK
          9: Ref
  - id: b_s13_transportation
    title: SECTION H — TRANSPORTATION
    precondition:
    - predicate: BORN_AFTER_1996_05_15_2.outcome != 1
      hint: Asked only when question BORN_AFTER_1996_05_15 is not "Yes, born after May 15, 1996".
    items:
    - id: H1
      kind: Question
      title: I would like to ask you about the means of transportation that ..... uses for local travel on his/her own or with someone else. This includes trips to the doctor, recreational events or any other local trips under 80 km (50 miles). Because of .....’s condition, does your car have special features or equipment, such as a lift device or a large trunk to carry a wheelchair?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          5: DO NOT OWN A CAR
          7: Don’t know
          9: Refusal
    - id: H2
      kind: Question
      title: Do you NEED ANY OTHER special features or equipment for your car because of .....’s condition?
      precondition:
      - predicate: not (H1.outcome == 3)
        hint: Asked only when question H1 is not "No".
      - predicate: not (H1.outcome == 5)
        hint: Asked only when question H1 is not "DO NOT OWN A CAR".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          7: Don’t know
          9: Refusal
  - id: b_s14_car_equipment
    title: Special car equipment
    precondition:
    - predicate: not (H1.outcome == 5)
      hint: Asked only when question H1 is not "DO NOT OWN A CAR".
    - predicate: not (H2.outcome in [7, 9])
      hint: Asked only when question H2 is none of "Don’t know", "Refusal".
    items:
    - id: H3
      kind: Question
      title: Because of .....’s condition, do you NEED any special features or equipment (for your car)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s14_car_reasons
    title: Why special car equipment is not available
    precondition:
    - predicate: not (H1.outcome == 5)
      hint: Asked only when question H1 is not "DO NOT OWN A CAR".
    - predicate: not (H2.outcome in [7, 9])
      hint: Asked only when question H2 is none of "Don’t know", "Refusal".
    - predicate: not (H3.outcome in [3, 98, 99])
      hint: Asked only when question H3 is none of "No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: H4a
      kind: Question
      title: 'H4. Why do you not have these special features or equipment for your car? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Not covered by insurance'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H4b
      kind: Question
      title: H4. (b) Too expensive
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H4c
      kind: Question
      title: H4. (c) Only needed occasionally
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H4d
      kind: Question
      title: H4. (d) Other reason, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
  - id: b_s14_bus_service
    title: Specialized bus service
    items:
    - id: H5
      kind: Question
      title: Some communities have a specialized bus service for people who have difficulty using regular transportation services. (To use this service, people can call ahead and ask to be picked up). Is this service available in your area?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: H6
      kind: Question
      title: Does ..... NEED this service?
      precondition:
      - predicate: not (H5.outcome == 1)
        hint: Asked only when question H5 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: H7
      kind: Question
      title: Does ..... use this service?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s14_bus_use
    title: Use of the specialized bus service
    precondition:
    - predicate: not (H7.outcome in [3, 98, 99])
      hint: Asked only when question H7 is none of "No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: H8
      kind: Question
      title: 'How often does he/she use this service? Interviewer: Read list. Mark one only.'
      input:
        control: Radio
        labels:
          1: Almost everyday for at least some part of the year
          2: Frequently
          3: Occasionally
          4: Seldom
          98: (x) Don’t know
          99: (r) Refusal
    - id: H9
      kind: Question
      title: IN THE PAST 12 MONTHS, did ..... have any difficulty using this service?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s14_bus_difficulty
    title: Difficulties using the specialized bus service
    precondition:
    - predicate: not (H7.outcome in [3, 98, 99])
      hint: Asked only when question H7 is none of "No", "(x) Don’t know", "(r) Refusal".
    - predicate: not (H9.outcome in [98, 99])
      hint: Asked only when question H9 is none of "(x) Don’t know", "(r) Refusal".
    - predicate: not (H9.outcome == 3)
      hint: Asked only when question H9 is not "No".
    items:
    - id: H10a
      kind: Question
      title: 'H10. What kind of difficulty did he/she have? I will read you a list. Please answer yes or no to each. Interviewer: Read list. (a) Service is needed more often than currently offered'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H10b
      kind: Question
      title: H10. (b) Impractical scheduling for child’s needs
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H10c
      kind: Question
      title: H10. (c) Booking rules don’t allow for last minute arrangements
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H10d
      kind: Question
      title: H10. (d) Too expensive
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: H10e
      kind: Question
      title: H10. (e) Other reason, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
  - id: b_s14_taxi
    title: Taxi use and cancelled activities
    items:
    - id: H11
      kind: Question
      title: IN THE PAST 12 MONTHS has ..... had to use a taxi service because of his/her condition or health problem?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: H12
      kind: Question
      title: 'How often did he/she use a taxi service? Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (H11.outcome in [3, 98, 99])
        hint: Asked only when question H11 is none of "No", "(x) Don’t know", "(r) Refusal".
      input:
        control: Radio
        labels:
          1: Almost everyday for at least some part of the year
          2: Frequently
          3: Occasionally
          4: Seldom
          98: (x) Don’t know
          99: (r) Refusal
    - id: H13
      kind: Question
      title: IN THE PAST 12 MONTHS, for local trips which you must take with ....., have you had to cancel or reschedule some activities because of problems with transportation services?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: H14
      kind: Question
      title: IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses for .....’s transportation, for example, his/her travel to and from treatment, therapy or other medical or rehabilitation services?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s14_costs
    title: Transportation costs
    precondition:
    - predicate: not (H14.outcome in [3, 98, 99])
      hint: Asked only when question H14 is none of "No", "(x) Don’t know", "(r) Refusal".
    items:
    - id: H15
      kind: Question
      title: What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? $ .00
      input:
        control: Editbox
        min: 1
        max: 999999
        left: $
    - id: H16
      kind: Question
      title: 'Which one of the following expense groups is the best estimate of the direct costs to you or your family? I will read you a list. Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: H15.outcome is None or not (H15.outcome >= 1)
        hint: Asked only when no dollar amount was given in question H15.
      input:
        control: Radio
        labels:
          1: Less than $100
          2: $100 to less than $200
          3: $200 to less than $500
          4: $500 to less than $1000
          5: $1000 to less than $2000
          6: $2000 to less than $5000
          7: $5000 or more
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s15_insurance
    title: Insurance coverage
    items:
    - id: I1a
      kind: Question
      title: 'I1. This question is about insurance coverage. Please include any private, government or employer-paid plans. Do you have insurance that covers all or part of: Interviewer: Read list. (a) the cost of .....’s prescription medications?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: I1b
      kind: Question
      title: I1. (b) the cost of ....’s eye glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: I1c
      kind: Question
      title: I1. (c) hospital charges for a private or semi-private room?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
  - id: b_s15_tax_credits
    title: Federal income tax credits
    items:
    - id: I2
      kind: Question
      title: The next few questions are about FEDERAL income tax credits. Did you claim Child Care Expenses for ..... with your 2000 income tax return?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I3
      kind: Question
      title: Did you receive it?
      precondition:
      - predicate: not (I2.outcome in [3, 98, 99])
        hint: Asked only when question I2 is none of "No", "(x) Don’t know", "(r) Refusal".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I4
      kind: Question
      title: Did you claim Medical Expenses for ..... with your 2000 income tax return?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I5
      kind: Question
      title: Did you receive it?
      precondition:
      - predicate: not (I4.outcome in [3, 98, 99])
        hint: Asked only when question I4 is none of "No", "(x) Don’t know", "(r) Refusal".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I6
      kind: Question
      title: Did you claim a Disability Tax Credit for ...... with your 2000 income tax return?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I7
      kind: Question
      title: Did you receive it?
      precondition:
      - predicate: not (I6.outcome == 3)
        hint: Asked only when question I6 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: (x) Don’t know
          99: (r) Refusal
    - id: I8a
      kind: Question
      title: 'I8. Why did you not claim the Disability Tax Credit? Interviewer: Read list. (a) You did not know it existed'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
  - id: b_s15_i8_reasons
    title: Other reasons for not claiming the Disability Tax Credit
    precondition:
    - predicate: not (I8a.outcome == 1)
      hint: Asked only when question I8a is not "Yes".
    items:
    - id: I8b
      kind: Question
      title: I8. (b) You did not think that .....would meet the eligibility requirements
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: I8c
      kind: Question
      title: I8. (c) You were not able to obtain the disability certificate (Form T2201) from your doctor
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
    - id: I8d
      kind: Question
      title: I8. (d) Other reason, specify
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: DK
          99: Ref
  - id: b_s15_income
    title: Household income
    items:
    - id: I9
      kind: Question
      title: For the year ending December 31, 2000, what is your best estimate of the total income, before taxes and deductions, of all household members, including yourself, from all sources? $ .00 (Enter 0 for no income or loss, 98 for Don’t know, 99 for Refusal)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: I10
      kind: Question
      title: 'Can you estimate in which of the following groups your HOUSEHOLD INCOME fell? I will read you a list. Interviewer: Read list. Mark one only.'
      precondition:
      - predicate: not (I9.outcome >= 0 and I9.outcome != 98 and I9.outcome != 99)
        hint: Asked only when the income in I9 was not given (Don’t know or Refusal).
      input:
        control: Dropdown
        labels:
          1: $1 to less than $5000
          2: $5,000 to less than $10,000
          3: $10,000 to less than $15,000
          4: $15,000 to less than $20,000
          5: $20,000 to less than $30,000
          6: $30,000 to less than $40,000
          7: $40,000 to less than $50,000
          8: $50,000 to less than $60,000
          9: $60,000 to less than $80,000
          10: $80,000 or more
          98: (x) Don’t know
          99: (r) Refusal
  - id: b_s16_follow_up
    title: FOLLOW-UP
    items:
    - id: FOLLOW_UP
      kind: Question
      title: That’s the end of our questions. Someone from Statistics Canada may contact you (.....’s parent/guardian) in a year or two to find out more about ..... . In case there are difficulties reaching you (them), could you please give me the name, address and telephone number of a family member or friend we could contact? We will only call this person if you move (the parent/guardian moves) and then only to obtain the new address or telephone number.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: (r) Refusal
  - id: b_s16_contact
    title: Name and Address of Other Contact
    precondition:
    - predicate: not (FOLLOW_UP.outcome in [3, 99])
      hint: Asked only when question FOLLOW-UP is none of "No", "(r) Refusal".
    items:
    - id: CONTACT_FIRSTNAME
      kind: Question
      title: 'Name and Address of Other Contact: First name(s)'
      input:
        control: Textarea
    - id: CONTACT_FAMILYNAME
      kind: Question
      title: 'Name and Address of Other Contact: Family name'
      input:
        control: Textarea
    - id: CONTACT_APT
      kind: Question
      title: 'Address: Apt. No.'
      input:
        control: Textarea
    - id: CONTACT_STREET
      kind: Question
      title: 'Address: Number and Street or lot and concession or exact location'
      input:
        control: Textarea
    - id: CONTACT_CITY
      kind: Question
      title: 'Address: City, Town, Village or Municipality'
      input:
        control: Textarea
    - id: CONTACT_PROVINCE
      kind: Question
      title: 'Address: Province or Territory'
      input:
        control: Textarea
    - id: CONTACT_POSTAL
      kind: Question
      title: 'Address: Postal Code'
      input:
        control: Textarea
    - id: CONTACT_AREACODE
      kind: Question
      title: 'Telephone: Area code'
      input:
        control: Textarea
    - id: CONTACT_PHONE
      kind: Question
      title: 'Telephone: Telephone No.'
      input:
        control: Textarea
    - id: CONTACT_COMMENTS
      kind: Question
      title: COMMENTS
      input:
        control: Textarea
