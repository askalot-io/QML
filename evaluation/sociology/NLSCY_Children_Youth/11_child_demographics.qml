qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Child Demographics (DVS)"
  codeInit: |
    # Variables PRODUCED by this section (for downstream sections)
    relationship_to_child = 0   # 1=Birth parent .. 9=Unrelated, used in Parenting/Custody

  blocks:
    # =========================================================================
    # BLOCK 1: CHILD DEMOGRAPHICS (DVS)
    # =========================================================================
    # DVS-INT, DVS-Q1, DVS-Q2
    # Start of the Children's Questionnaire. Confirms respondent's
    # relationship to the selected child and sibling relationship.
    # =========================================================================
    - id: b_dvs
      title: "Child Demographics"
      items:
        # DVS-INT: Introduction to children's questionnaire
        - id: q_dvs_int
          kind: Comment
          title: "I need to confirm some of the information that we collected earlier, since it is important in determining which questions we need to ask you about the child."

        # DVS-Q1: Relationship of respondent to child
        - id: q_dvs_q1
          kind: Question
          title: "What is your relationship to the child?"
          input:
            control: Dropdown
            labels:
              1: "Birth parent"
              2: "Step parent (including common-law parent)"
              3: "Adoptive parent"
              4: "Foster parent"
              5: "Sister/Brother"
              6: "Grandparent"
              7: "In-law"
              8: "Other related"
              9: "Unrelated"
          codeBlock: |
            relationship_to_child = q_dvs_q1.outcome

        # DVS-Q2: Relationship of selected child to first child
        # Only asked when there are multiple selected children in the household
        - id: q_dvs_q2
          kind: Question
          title: "What is this child's relationship to the first selected child?"
          input:
            control: Radio
            labels:
              1: "Full sister/brother by birth"
              2: "Sister/brother - half, step, adopted, foster (including common-law siblings)"
              3: "Other related"
              4: "Unrelated"
