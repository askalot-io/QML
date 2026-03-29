qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language Knowledge and Use (Section F)"

  codeInit: |
    # Routing variable PRODUCED by this section — read by all downstream
    # language and background sections.
    # Values: 1=English+knows other (->G), 2=Eng+Fr (->H), 3=Eng+Other (->J),
    #         4=French (->K), 5=Fr+Other (->L), 6=Other (->M),
    #         7=English-only (->T)
    lang_path = 0

  blocks:
    # =========================================================================
    # BLOCK: LANGUAGE FILTER
    # =========================================================================
    # F1:  Main language — major routing point for the entire questionnaire
    # F1a: Whether English-only respondent knows any other language
    #      (determines G vs T path)
    #
    # Routing summary from F1:
    #   1 (English)       -> F1a -> if Yes: lang_path=1 (->G)
    #                             -> if No:  lang_path=7 (->T)
    #   2 (Eng + Fr)      -> lang_path=2 (->H)
    #   3 (Eng + Other)   -> lang_path=3 (->J)
    #   4 (French)        -> lang_path=4 (->K)
    #   5 (Fr + Other)    -> lang_path=5 (->L)
    #   6 (Other)         -> lang_path=6 (->M)
    # =========================================================================
    - id: b_language_filter
      title: "Language Knowledge and Use"
      items:
        # F1: Main language
        # codeBlock sets lang_path for non-English responses (2-6).
        # English (1) is handled by F1a below.
        - id: q_f1
          kind: Question
          title: "What is your main language, that is, the language in which you are most at ease? (Report two if the respondent is equally at ease in two languages.)"
          codeBlock: |
            if q_f1.outcome == 2:
                lang_path = 2
            elif q_f1.outcome == 3:
                lang_path = 3
            elif q_f1.outcome == 4:
                lang_path = 4
            elif q_f1.outcome == 5:
                lang_path = 5
            elif q_f1.outcome == 6:
                lang_path = 6
          input:
            control: Radio
            labels:
              1: "English"
              2: "English and French"
              3: "English and Other"
              4: "French"
              5: "French and Other"
              6: "Other"

        # F1 specify: open text for "Other" responses
        - id: q_f1_specify
          kind: Question
          title: "Please specify the other language:"
          precondition:
            - predicate: q_f1.outcome in [3, 5, 6]
          input:
            control: Textarea
            placeholder: "Specify language..."

        # F1a: Knowledge of other languages (English-only respondents)
        # Original codes: 7=Yes, 8=No; modeled as Switch (0=No, 1=Yes)
        - id: q_f1a
          kind: Question
          title: "Have you ever had any knowledge or understanding of a language other than English?"
          precondition:
            - predicate: q_f1.outcome == 1
          codeBlock: |
            if q_f1a.outcome == 1:
                lang_path = 1
            else:
                lang_path = 7
          input:
            control: Switch
            off: "No"
            on: "Yes"
