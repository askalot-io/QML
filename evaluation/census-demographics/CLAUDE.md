# Census & Demographics

Population censuses, demographic surveys, household surveys, and labour force instruments. These questionnaires collect foundational data about populations -- who people are, where they live, how they work, and what they earn.

## Typical design patterns

- **Household rosters**: enumerate all members, then loop per-person questions
- **Proxy reporting**: one respondent answers for the entire household
- **Address-based sampling**: dwelling characteristics before person questions
- **Reference periods**: "in the last 12 months", "during the week of..."
- **Universe filters**: age/sex gates that skip entire sections (e.g., labour force questions only for 15+)

## Topics covered

- Population counts, age, sex, marital status, ethnicity, language
- Housing characteristics, tenure, dwelling type, utilities
- Education attainment, school attendance
- Labour force participation, occupation, industry, hours worked
- Income, earnings, transfers, pensions
- Migration, country of birth, citizenship
- Disability, health insurance coverage
- Household composition, family relationships

## Instruments in this category

- National censuses (US Census, UK Census, Japan, Brazil, IPUMS archive)
- American Community Survey (ACS)
- Labour Force Surveys (LFS, EU-LFS, CPS)
- Household spending/expenditure surveys (SHS)
- Income dynamics surveys (SLID, EU-SILC)
- Generic demographics modules used across surveys

## QML conversion notes

These instruments tend to have straightforward skip logic (age/sex filters) but complex household roster structures. The main challenge is representing per-person loops and proxy respondent routing in QML's flat item model.
