# Authoring lints fixture (#532): a Comment that asks, and a Roster subject
# that can never answer.
#
# Every finding here is a WARNING — the file has zero error-severity issues, so
# it stays is_valid=True through Portor's error-only gate. It carries both the
# positive and the negative arm of each lint, so a predicate that widens too far
# fails on the negatives rather than passing silently.
#
# comment_titled_as_question — POSITIVES:
#   - q_ask_name: carries '?' mid-title, followed by a format hint. The
#     question-mark arm is deliberately unanchored so this real shape is caught.
#   - q_ask_contact: "Please print …" — an inscription verb in request position,
#     no question mark. This is the ACS shape the lint exists for.
#   - q_ask_bare_imperative: "List every vehicle …" — verb at sentence start.
# comment_titled_as_question — NEGATIVES:
#   - q_instruction: "Please answer … honestly." — an instruction to ANSWER, not
#     to write something down here. A Comment exists to say this.
#   - q_instruction_read: "Please read …" — same, and the closest near-miss to
#     the verb list.
#   - q_section_header: a plain label, no verb and no '?'.
#   - q_describes_a_list: contains the word "list" as a NOUN, mid-sentence, so
#     the request-position anchor must not fire.
#   - q_real_question: a Question titled with '?' — correct authoring, and the
#     lint is Comment-only.
#
# roster_subject_not_answerable — POSITIVE:
#   - b_broken_roster declares subjectFrom: q_roster_note, a Comment.
# roster_subject_not_answerable — NEGATIVE:
#   - b_good_roster declares subjectFrom: q_good_name, a Textarea Question.
qmlVersion: "2.0"

questionnaire:
  title: "Authoring lints"

  blocks:
    - id: b_comments
      title: "Comment titles"
      items:
        # --- positives ------------------------------------------------------
        - id: q_ask_name
          kind: Comment
          title: "What is this person's name? (Last name, First name, MI)"

        - id: q_ask_contact
          kind: Comment
          title: "Please print the name and telephone number of the person filling out this form."

        - id: q_ask_bare_imperative
          kind: Comment
          title: "List every vehicle kept at this address."

        # --- negatives ------------------------------------------------------
        - id: q_instruction
          kind: Comment
          title: "Please answer the following questions honestly."

        - id: q_instruction_read
          kind: Comment
          title: "Please read the following section carefully before continuing."

        - id: q_section_header
          kind: Comment
          title: "Section 2: Housing"

        - id: q_describes_a_list
          kind: Comment
          title: "The next section covers a list of household expenses."

        - id: q_real_question
          kind: Question
          title: "How many people live at this address?"
          input:
            control: Editbox
            min: 1
            max: 12

    - id: b_roster_source
      title: "Roster sources"
      items:
        - id: q_good_members
          kind: Question
          title: "Which members are present?"
          input:
            control: Checkbox
            labels:
              1: "Member 1"
              2: "Member 2"

        - id: q_broken_members
          kind: Question
          title: "Which guests are present?"
          input:
            control: Checkbox
            labels:
              1: "Guest 1"
              2: "Guest 2"

    # subjectFrom points at an answerable Textarea inside the block — no warning.
    - id: b_good_roster
      kind: Roster
      title: "Members"
      iterateOver: "q_good_members.outcome"
      labels:
        1: "Member 1"
        2: "Member 2"
      subjectFrom: q_good_name
      items:
        - id: q_good_name
          kind: Question
          title: "What is this member's first name?"
          input:
            control: Textarea

    # subjectFrom points at a Comment, which carries no outcome — WARNING.
    - id: b_broken_roster
      kind: Roster
      title: "Guests"
      iterateOver: "q_broken_members.outcome"
      labels:
        1: "Guest 1"
        2: "Guest 2"
      subjectFrom: q_roster_note
      items:
        - id: q_roster_note
          kind: Comment
          title: "Guest details follow."

        - id: q_guest_age
          kind: Question
          title: "How old is this guest?"
          input:
            control: Editbox
            min: 0
            max: 120
