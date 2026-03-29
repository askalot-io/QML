# Education & Psychology

Educational assessments, psychometric instruments, learning evaluations, and psychological scales. These questionnaires measure knowledge, aptitude, attitudes toward learning, personality traits, mental states, and developmental outcomes.

## Typical design patterns

- **Multi-form test booklets**: different students get different item subsets (PISA, TIMSS)
- **Likert scale batteries**: blocks of items on agreement/frequency scales
- **Reverse-coded items**: alternating positive/negative wording to detect acquiescence
- **Scoring algorithms**: raw responses transformed into composite scores with cutoffs
- **Multi-respondent designs**: student + teacher + parent + school questionnaires for the same study
- **Adaptive testing**: item selection based on prior responses (CAT)

## Topics covered

- Student background, attitudes toward school, learning habits
- Teacher characteristics, classroom practices, efficacy beliefs
- School resources, climate, policies
- Educational planning, savings, aspirations
- Personality (Big Five, HEXACO, 16PF via IPIP)
- Self-esteem, self-efficacy, locus of control
- Stress, mindfulness, burnout
- Academic motivation, learning styles
- Depression, anxiety screening in educational settings
- Child development, temperament, behavioural assessment

## Instruments in this category

- PISA (student/school questionnaires, 2000-2022)
- TIMSS (student/teacher/school/home/curriculum, Grade 4 & 8)
- PIRLS (reading literacy context questionnaires)
- IPIP personality inventories (public domain, 3,320+ items)
- Perceived Stress Scale (PSS), MAAS, FFMQ
- Rosenberg Self-Esteem Scale
- Academic Motivation Scale (AMS)
- Teacher efficacy scales (TSES, Bandura, Gibson & Dembo)
- VARK learning styles
- Educational planning surveys (SAEP)

## QML conversion notes

Psychometric instruments present unique challenges: reverse-coded items need careful postcondition design, composite scoring requires codeBlock computation across multiple items, and multi-form designs (where different respondents get different item subsets) push QML's block-level precondition system. The IPIP public domain collection (250+ scales) is an excellent source for testing scale-battery patterns.
