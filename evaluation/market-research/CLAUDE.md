# Market Research & Business

Customer experience surveys, product research, employee engagement, usability studies, and business assessment instruments. These questionnaires measure satisfaction, loyalty, preferences, and organizational health.

## Typical design patterns

- **Single-item metrics**: NPS (0-10), CSAT (1-5), CES -- one question + open follow-up
- **Paired expectation/perception**: SERVQUAL asks the same dimension twice (expected vs. actual)
- **Semantic differentials**: bipolar adjective pairs on a scale (UEQ)
- **Conjoint/choice experiments**: respondents choose between product configurations
- **Kano pairs**: functional + dysfunctional question per feature
- **Branching by product/service**: skip to relevant section based on what was purchased
- **Quota sampling logic**: screening questions to fill demographic quotas

## Topics covered

- Customer satisfaction (CSAT), loyalty (NPS), effort (CES)
- Service quality (SERVQUAL)
- Product-market fit (Sean Ellis test)
- Brand awareness, recognition, perception
- Employee engagement (Gallup Q12), satisfaction, retention
- System/product usability (SUS, UEQ)
- Technology acceptance (TAM)
- Feature prioritization (Kano model)
- Pricing research (Van Westendorp, Gabor-Granger)
- Market segmentation, buyer personas

## Instruments in this category

*(Empty -- candidates for future addition)*

- NPS / CSAT / CES standard surveys
- SERVQUAL (44-item service quality)
- System Usability Scale (SUS, 10 items, public domain)
- User Experience Questionnaire (UEQ, 26 items, free)
- Gallup Q12 employee engagement
- Kano model questionnaires
- Technology Acceptance Model (TAM)
- Sean Ellis PMF survey
- Qualtrics/Typeform/SurveyMonkey templates

## QML conversion notes

Market research instruments are typically short but may involve complex scoring (NPS promoter/detractor classification, SUS score formula, SERVQUAL gap analysis). The main QML opportunity is encoding scoring logic in codeBlocks and using postconditions to enforce consistency (e.g., importance ratings should not all be identical). Conjoint and choice experiments would require QML language extensions for randomized stimulus presentation.
