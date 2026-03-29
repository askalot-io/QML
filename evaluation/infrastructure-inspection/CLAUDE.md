# Infrastructure & Inspection

Physical infrastructure inspection forms, manufacturing quality audits, vehicle safety checks, incident response protocols, and operational readiness assessments. These instruments ensure that physical systems, facilities, and processes meet defined standards.

## Typical design patterns

- **Component-by-component inspection**: systematic check of each subsystem (bridge deck, superstructure, substructure)
- **Pass/Fail/N-A with deficiency codes**: ternary response with coded severity when failed
- **Condition rating scales**: numeric condition scores (0-9 for bridges, pass/advisory/fail for vehicles)
- **Photographic evidence triggers**: failed items require photo documentation
- **Reinspection scheduling**: severity of findings determines next inspection interval
- **Hierarchical sections**: building > floor > room > system > component
- **Computed compliance scores**: weighted aggregate of individual item scores determines overall status

## Topics covered

- Bridge inspection: FHWA SI&A coding guide, NBI condition ratings
- Elevator inspection: periodic inspection checklists, pre-inspection forms
- Vehicle inspection: DOT annual inspection (FMCSA Form 6), UK MOT (VT29), commercial vehicle safety
- Building inspection: home inspection (InterNACHI), construction safety, building code compliance
- Water/wastewater: EPA NPDES compliance inspection, sanitary survey checklists
- Manufacturing quality: ISO 9001 audit checklists, factory audit, supplier assessment
- Construction: OSHA safety inspection, quality control checklists
- Power/utility: NERC CIP security audit, grid reliability assessment
- Cloud/IT infrastructure: AWS Well-Architected Review, data center assessment, IT audit
- Incident response: SRE postmortem templates (Google, PagerDuty, Atlassian), security incident checklists
- Disaster recovery: BDR assessment questionnaires, business continuity plans
- Supply chain: CISA vendor SCRM template, vendor risk assessment
- Software deployment: release readiness checklists, Go/No-Go production readiness

## Instruments in this category

*(Empty -- candidates for future addition)*

- FHWA Bridge Inspection SI&A Coding Guide (268 pages, coded fields)
- NYC Elevator Periodic Inspection Checklist
- FMCSA Part 396 Form 6 (annual vehicle inspection)
- UK DVSA VT29 MOT Inspection Checklist (fillable)
- EPA NPDES Compliance Inspection Manual
- ISO 9001:2015 audit checklists
- AWS Well-Architected Framework
- Google SRE Postmortem Template

## QML conversion notes

Infrastructure inspection instruments push QML in a different direction than surveys: they emphasize deficiency tracking (a failed item opens a sub-flow for severity, photos, corrective action), computed aggregate scores, and reinspection logic. Postconditions are critical for enforcing consistency (e.g., an item rated "poor condition" must have a deficiency note). The hierarchical component structure maps well to QML blocks with preconditions. The main gap is that QML doesn't natively support photo/file attachment items -- these would need a new input type or workaround.
