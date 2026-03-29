qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Motor and Social Development (MSD)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0           # age of child in years (0-11)
    child_age_months = 0    # age of child in months (0-143)

  blocks:
    # =========================================================================
    # BLOCK 1: MOTOR AND SOCIAL DEVELOPMENT
    # =========================================================================
    # MSD-C1: IF AGE > 3 YEARS → skip entire section
    # MSD-I1: Introduction
    # MSD-Q1 through Q48: Developmental milestone questions
    # Age-band routing via preconditions on child_age_months:
    #   0-3m:  Q1-Q15    → exit at C16
    #   4-6m:  Q8-Q22    → exit at C23
    #   7-9m:  Q12-Q26   → exit at C27
    #   10-12m: Q18-Q32  → exit at C33
    #   13-15m: Q22-Q36  → exit at C37
    #   16-18m: Q26-Q40  → exit at C41
    #   19-21m: Q29-Q43  → exit at C44
    #   22-47m: Q34-Q48
    # =========================================================================
    - id: b_msd
      title: "Motor and Social Development"
      precondition:
        - predicate: child_age <= 3
      items:
        # MSD-I1: Introduction
        - id: q_msd_intro
          kind: Comment
          title: "The following questions are about this child's motor and social development."

        # -----------------------------------------------------------------
        # Q1-Q7: First appears in 0-3m band (no lower age gate needed)
        # Upper bound: Q1-Q7 last appear in 4-6m band → exit at C16 for
        # children 0-3m, but Q1-Q7 are also in 4-6m band.
        # Actually Q1-Q15 are in 0-3m; Q8-Q22 are in 4-6m.
        # So Q1-Q7 appear ONLY in 0-3m and 4-6m bands.
        # Children 7m+ exit via C23 at Q22, never reach Q1-Q7 anyway
        # because Q1-Q7 have no lower gate. But the age-band exit checks
        # (C16, C23, etc.) act as upper bounds on later questions.
        # For Q1-Q7: no minimum age needed; maximum handled by exit checks.
        # -----------------------------------------------------------------

        # MSD-Q1
        - id: q_msd_q1
          kind: Question
          title: "When lying on his/her stomach, has this child ever turned his/her head from side to side?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q2
        - id: q_msd_q2
          kind: Question
          title: "Have his/her eyes ever followed a moving object?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q3
        - id: q_msd_q3
          kind: Question
          title: "When lying on his/her stomach on a flat surface, has he/she ever lifted his/her head off the surface for a moment?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q4
        - id: q_msd_q4
          kind: Question
          title: "Have his/her eyes ever followed a moving object all the way from one side to the other?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q5
        - id: q_msd_q5
          kind: Question
          title: "Has he/she ever smiled at someone when that person talked to or smiled at (but did not touch) him/her?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q6
        - id: q_msd_q6
          kind: Question
          title: "When lying on his/her stomach, has he/she ever raised his/her head and chest from the surface while resting his/her weight on his/her lower arms or hands?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q7
        - id: q_msd_q7
          kind: Question
          title: "Has he/she ever turned his/her head around to look at something?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q8-Q11: First appears in 4-6m band → minimum age 4 months
        # -----------------------------------------------------------------

        # MSD-Q8
        - id: q_msd_q8
          kind: Question
          title: "When lying on his/her back and being pulled up to a sitting position, did this child ever hold his/her head stiffly so that it did not hang back as he/she was pulled up?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q9
        - id: q_msd_q9
          kind: Question
          title: "Has he/she ever laughed out loud without being tickled or touched?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q10
        - id: q_msd_q10
          kind: Question
          title: "Has he/she ever held in one hand a moderate size object such as a block or a rattle?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q11
        - id: q_msd_q11
          kind: Question
          title: "Has he/she ever rolled over on his/her own on purpose?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q12-Q15: First appears in 7-9m band → minimum age 7 months
        # -----------------------------------------------------------------

        # MSD-Q12
        - id: q_msd_q12
          kind: Question
          title: "Has this child ever seemed to enjoy looking in the mirror at him/herself?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q13
        - id: q_msd_q13
          kind: Question
          title: "Has he/she ever been pulled from a sitting to a standing position and supported his/her own weight with legs stretched out?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q14
        - id: q_msd_q14
          kind: Question
          title: "Has he/she ever looked around with his/her eyes for a toy which was lost or not nearby?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q15
        - id: q_msd_q15
          kind: Question
          title: "Has he/she ever sat alone with no help except for leaning forward on his/her hands or with just a little help from someone else?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C16: IF AGE 0-3 MONTHS → exit to Relationships
        # Modeled as: Q16+ requires child_age_months >= 4
        # -----------------------------------------------------------------

        # MSD-Q16
        - id: q_msd_q16
          kind: Question
          title: "Has he/she ever sat for 10 minutes without any support at all?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q17
        - id: q_msd_q17
          kind: Question
          title: "Has he/she ever pulled him/herself to a standing position without help from another person?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q18-Q21: First appears in 10-12m band → minimum age 10 months
        # -----------------------------------------------------------------

        # MSD-Q18
        - id: q_msd_q18
          kind: Question
          title: "Has this child ever crawled when left lying on his/her stomach?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q19
        - id: q_msd_q19
          kind: Question
          title: "Has he/she ever said any recognizable words such as \"mama\" or \"dada\"?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q20
        - id: q_msd_q20
          kind: Question
          title: "Has he/she ever picked up small objects such as raisins or cookie crumbs, using only his/her thumb and first finger?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q21
        - id: q_msd_q21
          kind: Question
          title: "Has he/she ever walked at least 2 steps with one hand held or holding on to something?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q22: First appears in 13-15m band → minimum age 13 months
        # But Q22 also appears in 4-6m band (Q8-Q22). Let me re-check:
        #   4-6m: Q8-Q22 → Q22 first appears at 4m
        # So Q22 minimum is 4 months, not 13. Q22 spans bands 4-6m through
        # 13-15m. Already covered by C16 gate (child_age_months >= 4).
        # -----------------------------------------------------------------

        # MSD-Q22
        - id: q_msd_q22
          kind: Question
          title: "Has this child ever waved good-bye without help from another person?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C23: IF AGE 4-6 MONTHS → exit to Relationships
        # Modeled as: Q23+ requires child_age_months >= 7
        # -----------------------------------------------------------------

        # MSD-Q23
        - id: q_msd_q23
          kind: Question
          title: "Has he/she ever shown by his/her behavior that he/she knows the names of common objects when somebody else names them out loud?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q24
        - id: q_msd_q24
          kind: Question
          title: "Has he/she ever shown that he/she wanted something by pointing, pulling, or making pleasant sounds rather than crying or whining?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q25
        - id: q_msd_q25
          kind: Question
          title: "Has he/she ever stood alone on his/her feet for 10 seconds or more without holding on to anything or another person?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q26
        - id: q_msd_q26
          kind: Question
          title: "Has this child ever walked at least 2 steps without holding on to anything or another person?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C27: IF AGE 7-9 MONTHS → exit to Relationships
        # Modeled as: Q27+ requires child_age_months >= 10
        # -----------------------------------------------------------------

        # MSD-Q27
        - id: q_msd_q27
          kind: Question
          title: "Has he/she ever crawled up at least 2 stairs or steps?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q28
        - id: q_msd_q28
          kind: Question
          title: "Has he/she said 2 recognizable words besides \"mama\" or \"dada\"?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q29-Q32: First appears in 19-21m band → minimum age 19 months
        # But Q29 also in 19-21m (Q29-Q43). Let me check all bands:
        #   13-15m: Q22-Q36 → Q29 is in this band (min 13m)
        #   19-21m: Q29-Q43 → Q29 is in this band
        # So Q29 first appears in 13-15m band. But C33 gates at 10-12m,
        # meaning children 10-12m exit before Q33. C27 gates at 7-9m.
        # Q29 is in bands: 13-15m, 16-18m, 19-21m, 22-47m.
        # The exit check that controls access to Q29 is C27 (7-9m exit).
        # After C27, children 10m+ continue. Q29 appears starting in
        # 13-15m band (Q22-Q36). But Q27-Q28 are already gated at 10m+.
        # Q29 should be gated at 13m+ based on the 13-15m band being
        # the earliest containing it.
        # Wait: 10-12m band is Q18-Q32, so Q29 IS in the 10-12m band.
        # So Q29 first appears at 10m. Already gated by C27 (>= 10m).
        # -----------------------------------------------------------------

        # MSD-Q29
        - id: q_msd_q29
          kind: Question
          title: "Has this child ever run?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q30
        - id: q_msd_q30
          kind: Question
          title: "Has he/she ever said the name of a familiar object, such as a ball?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q31
        - id: q_msd_q31
          kind: Question
          title: "Has he/she ever made a line with a crayon or pencil?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q32
        - id: q_msd_q32
          kind: Question
          title: "Did he/she ever walk up at least 2 stairs with one hand held or holding the railing?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C33: IF AGE 10-12 MONTHS → exit to Relationships
        # Modeled as: Q33+ requires child_age_months >= 13
        # -----------------------------------------------------------------

        # MSD-Q33
        - id: q_msd_q33
          kind: Question
          title: "Has he/she ever fed him/herself with a spoon or fork without spilling much?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q34-Q36: First appears in 22-47m band → minimum age 22 months
        # But check: 13-15m band is Q22-Q36, so Q34 is in 13-15m band.
        # Q34 first appears at 13m. Already gated by C33 (>= 13m).
        # -----------------------------------------------------------------

        # MSD-Q34
        - id: q_msd_q34
          kind: Question
          title: "Has this child ever let someone know, without crying, that wearing wet or soiled pants or diapers bothered him/her?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q35
        - id: q_msd_q35
          kind: Question
          title: "Has he/she ever spoken a partial sentence of 3 words or more?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q36
        - id: q_msd_q36
          kind: Question
          title: "Has he/she ever walked up stairs by him/herself without holding on to a rail?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C37: IF AGE 13-15 MONTHS → exit to Relationships
        # Modeled as: Q37+ requires child_age_months >= 16
        # -----------------------------------------------------------------

        # MSD-Q37
        - id: q_msd_q37
          kind: Question
          title: "Has he/she ever washed and dried his/her hands without any help except for turning the water on and off?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q38
        - id: q_msd_q38
          kind: Question
          title: "Has he/she ever counted 3 objects correctly?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q39
        - id: q_msd_q39
          kind: Question
          title: "Has he/she ever gone to the toilet alone?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q40
        - id: q_msd_q40
          kind: Question
          title: "Has he/she ever walked upstairs by him/herself with no help, stepping on each step with only one foot?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C41: IF AGE 16-18 MONTHS → exit to Relationships
        # Modeled as: Q41+ requires child_age_months >= 19
        # -----------------------------------------------------------------

        # MSD-Q41
        - id: q_msd_q41
          kind: Question
          title: "Does he/she know his/her own age and sex?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q42
        - id: q_msd_q42
          kind: Question
          title: "Has he/she ever said the names of at least 4 colors?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q43
        - id: q_msd_q43
          kind: Question
          title: "Has he/she ever pedaled a tricycle at least 10 feet?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C44: IF AGE 19-21 MONTHS → exit to Relationships
        # Modeled as: Q44+ requires child_age_months >= 22
        # -----------------------------------------------------------------

        # MSD-Q44
        - id: q_msd_q44
          kind: Question
          title: "Has he/she ever done a somersault without help from anybody?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q45
        - id: q_msd_q45
          kind: Question
          title: "Has he/she ever dressed him/herself without any help except for tying shoes and buttoning the backs of dresses?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q46
        - id: q_msd_q46
          kind: Question
          title: "Has he/she ever said his/her first and last name together without someone's help? (Nickname may be used for first name.)"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q47
        - id: q_msd_q47
          kind: Question
          title: "Has he/she ever counted out loud up to 10?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q48
        - id: q_msd_q48
          kind: Question
          title: "Has he/she ever drawn a picture of a man or woman with at least 2 parts of the body besides a head?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"
