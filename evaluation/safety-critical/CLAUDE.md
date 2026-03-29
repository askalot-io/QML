# Safety-Critical Systems

Checklists, inspection protocols, and structured assessment instruments used in domains where errors have life-safety or mission-critical consequences. These instruments enforce strict procedural compliance and leave no room for ambiguity.

## Typical design patterns

- **Phase-gated checklists**: must complete all items in Phase 1 before proceeding to Phase 2 (NASA FRR, WHO Surgical Safety)
- **Go/No-Go gates**: single failed item blocks the entire process
- **Multi-party verification**: different roles (pilot/copilot, surgeon/nurse) must independently confirm the same item
- **Mandatory sequencing**: items must be completed in exact order (pre-flight, taxi, takeoff)
- **Deficiency tracking**: failed items generate follow-up actions with severity classification
- **Override with justification**: some items allow deviation if documented and approved

## Topics covered

- Aviation: pre-flight checklists, accident investigation forms (NTSB 6120.1), ICAO procedures
- Nuclear: IAEA safety culture self-assessment, NRC inspection procedures, periodic safety review
- Medical/surgical: WHO Surgical Safety Checklist (Sign In/Time Out/Sign Out), anaesthesia checklists
- Maritime: port state control inspection, vessel safety checks, ISM Code compliance
- Rail: FRA track inspection, railroad workplace safety
- Chemical/process: OSHA PSM compliance, process safety review checklists
- Space: NASA mission readiness reviews (MRR, FRR, LRR), payload checklists
- Emergency/disaster: FEMA ICS forms, UN OCHA MIRA rapid assessment
- Fire safety: NFPA inspection checklists, sprinkler/alarm testing
- Military: readiness assessment (DA Form 7425), DRRS reporting
- Anti-doping: WADA doping control forms

## Instruments in this category

*(Empty -- candidates for future addition)*

- NTSB Form 6120.1 (aircraft accident/incident report)
- WHO Surgical Safety Checklist
- IAEA TECDOC-1125 / TECDOC-1321 (nuclear self-assessment questionnaires)
- FEMA ICS Forms Booklet (ICS-201 through ICS-225)
- NASA Mission Readiness Review procedures
- WADA Doping Control Form v13
- USCG vessel inspection books

## QML conversion notes

Safety-critical instruments are the ultimate test for formal verification. Every item matters -- a skipped or contradicted check can have catastrophic consequences. QML's postcondition system maps directly to Go/No-Go gates (postcondition: item must pass before flow continues). Phase-gated sequences map to block-level preconditions. The main challenges are multi-party verification (QML currently assumes a single respondent) and mandatory sequencing (QML's topological sort respects dependencies but doesn't enforce strict linear order within independent items).
