# Sociology & Social Science

Social surveys, political attitude studies, victimization surveys, time-use diaries, and longitudinal social studies. These questionnaires measure opinions, values, behaviours, and social structures across populations.

## Typical design patterns

- **Show-card assisted interviews**: interviewer reads question, respondent picks from a card
- **Split-ballot experiments**: different subsamples get different question wordings
- **Rotating modules**: core questions every wave + thematic modules that rotate
- **Scale batteries**: blocks of 5-15 items on the same response scale (e.g., 0-10 trust)
- **Time-use diaries**: structured activity logging with time slots
- **Longitudinal panel**: same respondents re-interviewed across waves

## Topics covered

- Social and institutional trust, political participation, voting
- Immigration attitudes, national identity, citizenship
- Subjective wellbeing, life satisfaction, happiness
- Media use, internet behaviour, social contacts
- Religion, values, moral attitudes
- Crime victimization, fear of crime, justice perceptions
- Time use, daily activities, work-life balance
- Family, gender roles, intergenerational relations
- Social inequality, class, social mobility
- Child development, parenting, youth outcomes (longitudinal)

## Instruments in this category

- European Social Survey (ESS) -- 12 rounds, 30+ countries
- General Social Survey (GSS) -- NORC, 1972-present
- International Social Survey Programme (ISSP)
- World Values Survey (WVS)
- Barometer surveys (Afrobarometer, Arab Barometer, Latinobarometro, LAPOP)
- Eurobarometer, Pew Research surveys
- SHARE (ageing/retirement in Europe)
- Time-use surveys (GSS Time Use)
- Victimization surveys (GSS Victimization)
- Longitudinal child/youth studies (NLSCY)

## QML conversion notes

Sociology instruments tend to have simpler skip logic than health surveys but rely heavily on show-cards, scale batteries, and split-ballot designs. The main QML challenges are representing randomized question ordering, split-sample experiments, and the show-card presentation layer. Postconditions are useful for enforcing ranking consistency and catching contradictory attitude responses.
