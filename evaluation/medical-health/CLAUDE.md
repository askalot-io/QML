# Medical & Health Research

Health surveys, clinical screening instruments, epidemiological surveillance, and patient-reported outcome measures. These questionnaires collect data about health status, behaviours, conditions, service utilization, and quality of life.

## Typical design patterns

- **Screening cascades**: a brief screener triggers a detailed follow-up module
- **Skip-out patterns**: "If no chronic conditions, skip to next section"
- **Recall periods**: "In the past 30 days...", "In the past 12 months..."
- **Severity scales**: Likert scales with clinical cutoff scoring (PHQ-9, AUDIT)
- **CATI interviewer instructions**: complex routing with interviewer probes
- **Module-based architecture**: core + optional/rotating modules (BRFSS, NHANES)

## Topics covered

- General health status, self-rated health
- Chronic conditions (diabetes, cardiovascular, respiratory, cancer)
- Mental health screening (depression, anxiety, stress, burnout)
- Health behaviours (smoking, alcohol, physical activity, nutrition, sleep)
- Health care access, utilization, barriers, waiting times
- Disability, activity limitations, functional status
- Reproductive health, maternal/child health, immunization
- Quality of life (WHOQOL, SF-36, EQ-5D, PROMIS)
- NCD risk factor surveillance (WHO STEPS)
- Emergency dispatch protocols and triage (ICS)

## Instruments in this category

- CDC surveys: BRFSS, NHANES modules, NHIS, YRBSS
- WHO instruments: STEPS, WHOQOL, WHODAS, AUDIT, WHS+, Surgical Safety Checklist
- DHS (Demographic and Health Surveys) -- health-focused demographic surveys
- National health surveys (CCHS, NPHS, EHIS)
- Disability surveys (PALS)
- Clinical screeners: PHQ-9, GAD-7, EPDS, SF-36, EQ-5D
- Patient-reported outcomes (PROMIS)

## QML conversion notes

Health surveys are among the most complex CATI instruments. Key challenges: deep screening cascades with many skip levels, module selection logic, clinical scoring computed across items, and age/sex-dependent routing that spans sections. Postconditions are especially valuable here for range checks on clinical measures and cross-validation between reported conditions and medication use.
