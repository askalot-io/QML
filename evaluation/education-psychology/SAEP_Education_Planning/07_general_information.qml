qmlVersion: "1.0"
questionnaire:
  title: "SAEP - General Information"
  codeInit: |
    # Extern: number of children 0-18 in household (from screening)
    num_children: range(0, 20)
    # Extern: whether saving for children outside household (from section F)
    f1_saving: {1, 2}
  blocks:
    # =========================================================================
    # SECTION G: GENERAL INFORMATION
    # =========================================================================
    # G1 is a complex filter:
    #   No children AND F1=No  -> G11
    #   No children AND F1=Yes -> G6
    #   All children 0-4       -> G4
    #   Otherwise              -> G2
    #
    # Modelled as four blocks with appropriate preconditions.
    # The "all children 0-4" edge case cannot be determined from num_children
    # alone across files, so G2-G3 gate on num_children >= 1 (the 0-4 case
    # is rare and the questions remain valid).
    # =========================================================================

    # ----- Block 1: Household Resources (G2-G3) -----
    # Shown when children are in the household (not all 0-4 in original,
    # simplified to num_children >= 1)
    - id: b_household_resources
      title: "Household Resources"
      precondition:
        - predicate: num_children >= 1
      items:
        # G2: Computer available for schoolwork
        - id: q_g2_computer
          kind: Question
          title: "Is there a computer available in your household that the children can use to do their school work or assignments?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # G3: Books or reading materials available
        - id: q_g3_books
          kind: Question
          title: "Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g. encyclopaedias, reference books, CD ROMs)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # ----- Block 2: Ethnicity (G4-G5) -----
    # Shown when children are in the household
    - id: b_ethnicity
      title: "Ethnic and Cultural Background"
      precondition:
        - predicate: num_children >= 1
      items:
        # G4: Mother's ethnic/cultural ancestry
        - id: q_g4_mother_ethnicity
          kind: Question
          title: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their mother belong? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Canadian"
              2: "Chinese"
              4: "Dutch (Netherlands)"
              8: "English"
              16: "French"
              32: "German"
              64: "Inuit/Eskimo"
              128: "Irish"
              256: "Italian"
              512: "Jewish"
              1024: "Metis"
              2048: "North American Indian"
              4096: "Polish"
              8192: "Scottish"
              16384: "South Asian"
              32768: "Ukrainian"
              65536: "Other"

        # G5: Father's ethnic/cultural ancestry
        - id: q_g5_father_ethnicity
          kind: Question
          title: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their father belong? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Canadian"
              2: "Chinese"
              4: "Dutch (Netherlands)"
              8: "English"
              16: "French"
              32: "German"
              64: "Inuit/Eskimo"
              128: "Irish"
              256: "Italian"
              512: "Jewish"
              1024: "Metis"
              2048: "North American Indian"
              4096: "Polish"
              8192: "Scottish"
              16384: "South Asian"
              32768: "Ukrainian"
              65536: "Other"

    # ----- Block 3: Language, Finances, Income (G6-G10) -----
    # Always shown (G6 is reached by all paths through G1)
    - id: b_language_finances
      title: "Language and Financial Information"
      items:
        # G6: Language spoken most often in household
        - id: q_g6_language_main
          kind: Question
          title: "What is the language spoken most often in your household?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Arabic"
              8: "Chinese"
              16: "German"
              32: "Italian"
              64: "Polish"
              128: "Portuguese"
              256: "Punjabi"
              512: "Spanish"
              1024: "Tagalog (Filipino)"
              2048: "Vietnamese"
              4096: "Other language"

        # G7: Other languages spoken in household
        - id: q_g7_language_other
          kind: Question
          title: "What other languages are spoken in your household? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "No other languages spoken"
              2: "English"
              4: "French"
              8: "Arabic"
              16: "Chinese"
              32: "German"
              64: "Italian"
              128: "Polish"
              256: "Portuguese"
              512: "Punjabi"
              1024: "Spanish"
              2048: "Tagalog (Filipino)"
              4096: "Vietnamese"
              8192: "Other language"

        # G8: Highest financial priority
        - id: q_g8_financial_priority
          kind: Question
          title: "From the following list, what is your household's highest financial priority?"
          input:
            control: Radio
            labels:
              1: "Everyday budget"
              2: "Savings for post-secondary education"
              3: "Retirement savings"
              4: "Other savings"
              7: "Don't know"
              8: "Refused"

        # G9: Household income sources (past 12 months)
        - id: q_g9_income_sources
          kind: Question
          title: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest"
              8: "Employment insurance"
              16: "Workers' compensation"
              32: "Benefits from Canada or Quebec Pension Plan"
              64: "Retirement pensions, superannuation and annuities"
              128: "Old Age Security and Guaranteed Income Supplement"
              256: "Child Tax Benefit"
              512: "Provincial or municipal social assistance or welfare"
              1024: "Child support"
              2048: "Alimony"
              4096: "Other"
              8192: "None"

        # G10: Total household income (flattened from hierarchical bisection)
        - id: q_g10_income
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          input:
            control: Dropdown
            labels:
              1: "No income"
              2: "Less than $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $49,999"
              9: "$50,000 to $59,999"
              10: "$60,000 to $79,999"
              11: "$80,000 or more"
              97: "Don't know"
              98: "Refused"

    # ----- Block 4: Consent (G11, G13) -----
    # Always shown; G13 has item-level precondition for children in household
    - id: b_consent
      title: "Data Sharing Consent"
      items:
        # G11: Statistics Canada data sharing consent
        - id: q_g11_data_sharing
          kind: Question
          title: "To avoid duplication, Statistics Canada has entered into a data sharing agreement under Section 12 of the Statistics Act with Human Resources Development Canada. Do you agree to let Statistics Canada share your information?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # G13: Record linkage consent
        # G12 (filter): if no children -> END; otherwise -> G13
        - id: q_g13_record_linkage
          kind: Question
          title: "As part of a related statistical study, the information you provide during this interview, in future, may be combined with post-secondary school records about the children in your household. Do you agree to let Statistics Canada combine this information?"
          precondition:
            - predicate: num_children >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
