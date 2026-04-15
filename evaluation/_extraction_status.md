# PDF → `_text.md` extraction status

Tracks which questionnaires in `evaluation/` have been processed through the current `askalot-inventory` preprocessor (Claude Sonnet 4.6 vision on AWS Bedrock, producing `<stem>_text.md` next to the source PDF).

**Model:** `us.anthropic.claude-sonnet-4-6` • **Region:** us-west-2 • **DPI:** 150 • **Concurrency:** 8

**Last batch run:** 2026-04-15 12:56 → 13:05 (9m 9s wall time, parallelism 2 × inner concurrency 8 = 16 concurrent Bedrock calls). Plus retries with the new `pdftotext` fallback.

## Legend

| State | Meaning |
|---|---|
| ✅ DONE | `_text.md` exists next to the PDF (current canonical extraction) |
| ✅ DONE (N pdftotext fb) | Same, with N pages routed through the `pdftotext` fallback because Bedrock refused them with a content-filter error |
| ⏳ PENDING | No text intermediate at all — needs Sonnet extraction |
| ✅ DONE (was has_ocr) | Legacy `_ocr.md` from the old `pdftotext` pipeline; kept as benchmark; needs fresh `_text.md` |
| 📜 has_docling (legacy) | Legacy `_docling.md` from the old Docling pipeline; kept as benchmark; needs fresh `_text.md` |
| 🛑 DEFERRED | Large PDF (>150 pages) postponed pending explicit approval due to cost |
| 📚 NOT QUESTIONNAIRE | Source is a reference document, framework, or coding manual — not a fill-in form or collection of survey questions. The text extraction is still valuable for context, but downstream inventory/QML/analysis work does not apply. |

## Non-questionnaire reference documents

These five sources were extracted into `_text.md` but on review are not questionnaires or forms — they're reference documents, frameworks, or coding manuals. Downstream inventory / QML / analysis steps that assume "collection of items to answer" do not apply to them.

| Pages | Source | Why it's not a questionnaire |
|---:|---|---|
| 45 | `safety-critical/OSHA_PSM_Guidelines.pdf` | OSHA compliance guidelines for Process Safety Management — pure regulatory guidance, no questions |
| 131 | `safety-critical/IAEA_TECDOC_1125.pdf` | IAEA "Self-assessment of operational safety for nuclear power plants" — methodology publication describing how to run a self-assessment, not the assessment itself |
| 36 | `safety-critical/IAEA_TECDOC_1321.pdf` | IAEA report titled "Highlights and good practices" summarizing two technical committee meetings; explicitly a findings report |
| 97 | `infrastructure-inspection/AWS_Well_Architected_Framework.pdf` | AWS whitepaper describing the five WAR pillars; the actual review questions live in the AWS Well-Architected Tool web app, not in this PDF |
| 124 | `infrastructure-inspection/FHWA_Bridge_Inspection_Guide.pdf` | FHWA "Recording and Coding Guide" — the National Bridge Inventory data dictionary that defines the 116+ items collected, not the form itself |

## Totals

| State | Files | Pages |
|---|---:|---:|
| ✅ DONE (questionnaires/forms, fully extracted) | 68 | 4747 |
| 📚 DONE but not a questionnaire (reference docs) | 5 | 433 |
| **Total** | **73** | **5180** |

The 12 `has_ocr` files have been refreshed via Sonnet, and the 3 deferred giants (GSS_2024, NIST_SP_800_53A, NHIS_2024) have been processed. Every PDF in the corpus now has a `_text.md` next to it. Legacy `_ocr.md` and `_docling.md` files remain in place as benchmark references.

**Refusal-pattern fix (2026-04-15 14:02 → 14:35):** 13 files were re-extracted after a prompt bug was discovered. The old user message `"Extract page {page_num} verbatim."` caused Sonnet to refuse transcription when the rasterizer-assigned page number didn't match the printed page number on the image (worst case: NIST_SP_800_53A had 430 / 733 pages refused with "The page shown in the image is labeled PAGE 39, not page 50. I can only transcribe…"). Fix: changed the user message to `"Extract all text from this image verbatim."` (no page number mentioned) and added a `_looks_like_refusal()` safety-net detector that routes meta-refusal responses through the same per-page `pdftotext` fallback used for content-filter blocks. After the re-run, the total refusal count across the corpus dropped from **653 to 0**.

## pdftotext fallback

Five PDFs hit Bedrock's model-baked content-filter ("Output blocked by content filtering policy") on at least one page. The fallback in `askalot_inventory/parse/claude_vision.py::_pdftotext_page_fallback` runs `pdftotext -layout -nodiag -nopgbrk -cropbox -f N -l N` on just that page and prefixes the result with `[FALLBACK pdftotext — Bedrock content-filter refused this page]` so downstream tools can see which pages were routed around the moderation. All five PDFs are now fully extracted; no manual intervention needed for future runs.

| Source | Pages | Fallback pages | Reason |
|---|---:|---:|---|
| `legal-regulatory/CBP_6059B_Customs_Declaration.pdf` | 1 | 1 | US customs declaration form (restricted-import lists) |
| `legal-regulatory/USCIS_I589_Asylum.pdf` | 12 | 1 | Asylum application (persecution screening questions) |
| `compliance-risk/PCI_DSS_SAQ_A/PCI_DSS_v4_SAQ_A.pdf` | 40 | 1 | PCI-DSS payment card self-assessment (cause less obvious) |
| `safety-critical/OSHA_PSM_Guidelines.pdf` | 45 | 23 | Process Safety Management for highly hazardous chemicals |
| `safety-critical/IAEA_TECDOC_1125.pdf` | 131 | 1 | IAEA nuclear safety guidance |

## Deferred files (now done)

The three large PDFs originally deferred for cost reasons have been processed in the giants batch (2026-04-15 13:26 → 13:55, ~30 minutes wall time, ~$20 spend):

- `sociology/GSS_2024/GSS2024_Ballot1.pdf` — 309 pages, 11 min
- `compliance-risk/NIST_CSF/NIST_SP_800_53A_Assessment.pdf` — 733 pages, 20 min
- `medical-health/NHIS_2024.pdf` — 1017 pages, 30 min

## Files

| Pages | State | PDF |
|---:|---|---|
| 1 | ✅ DONE (1 pdftotext fb) | `legal-regulatory/CBP_6059B_Customs_Declaration.pdf` |
| 1 | ✅ DONE | `infrastructure-inspection/UK_MOT_VT29_Checklist.pdf` |
| 1 | ✅ DONE | `infrastructure-inspection/FMCSA_Vehicle_Inspection_Form6.pdf` |
| 1 | ✅ DONE | `medical-health/WHO_Surgical_Safety/WHO_surgical_safety_checklist.pdf` |
| 2 | ✅ DONE | `census-demographics/Japan_Census_2020/Japan_Census_2020.pdf` |
| 2 | ✅ DONE | `infrastructure-inspection/NYC_Elevator_Inspection.pdf` |
| 3 | ✅ DONE | `medical-health/WHOQOL_BREF/WHOQOL_BREF.pdf` |
| 3 | ✅ DONE | `education-psychology/Mindfulness_MAAS/MAAS.pdf` |
| 4 | ✅ DONE | `compliance-risk/ISO_45001_Audit/ISO_45001_Audit_Checklist.pdf` |
| 4 | ✅ DONE | `education-psychology/Teacher_Efficacy_TSES/TSES_Forms.pdf` |
| 4 | ✅ DONE | `education-psychology/Teacher_Efficacy_TSES/Bandura_Teacher_Efficacy.pdf` |
| 5 | ✅ DONE | `compliance-risk/Wolfsberg_FCCQ/Wolfsberg_FCCQ_v1.2.pdf` |
| 5 | ✅ DONE | `safety-critical/NASA_Mission_Readiness_Review.pdf` |
| 6 | ✅ DONE | `safety-critical/UN_OCHA_MIRA_v3.pdf` |
| 8 | ✅ DONE | `census-demographics/US_Census_2020/US_Census_2020.pdf` |
| 8 | ✅ DONE | `census-demographics/UK_Census_2021/UK_Census_2021_Individual_England.pdf` |
| 9 | ✅ DONE | `legal-regulatory/ICC_Victim_Application.pdf` |
| 9 | ✅ DONE | `legal-regulatory/Bankruptcy_Form_122A2.pdf` |
| 10 | ✅ DONE | `safety-critical/WADA_Doping_Control_v13.pdf` |
| 10 | ✅ DONE | `safety-critical/NTSB_6120_1.pdf` |
| 12 | ✅ DONE | `education-psychology/TIMSS_2019_Grade8/TIMSS_2019_School_8.pdf` |
| 12 | ✅ DONE | `education-psychology/TIMSS_2019_Grade8/TIMSS_2019_Teacher_Math_8.pdf` |
| 12 | ✅ DONE | `legal-regulatory/Bankruptcy_Form_107.pdf` |
| 12 | ✅ DONE (1 pdftotext fb) | `legal-regulatory/USCIS_I589_Asylum.pdf` |
| 13 | ✅ DONE | `compliance-risk/Wolfsberg_CBDDQ/Wolfsberg_CBDDQ_v1.4.pdf` |
| 14 | ✅ DONE (was has_ocr) | `census-demographics/Demographics/Demographics.pdf` |
| 14 | ✅ DONE | `census-demographics/Brazil_Census_2022/Brazil_Census_2022_Sample.pdf` |
| 14 | ✅ DONE | `legal-regulatory/USCIS_N400_Naturalization.pdf` |
| 15 | ✅ DONE | `legal-regulatory/SSA_3368_Disability_Report.pdf` |
| 20 | ✅ DONE | `education-psychology/TIMSS_2019_Grade4/TIMSS_2019_Home_4.pdf` |
| 20 | ✅ DONE (was has_ocr) | `census-demographics/ACS_2025/ACS_2025.pdf` |
| 22 | ✅ DONE | `sociology/ISSP_2024/ISSP_2024_Digital_Societies.pdf` |
| 24 | ✅ DONE | `legal-regulatory/USCIS_I485_Permanent_Residence.pdf` |
| 24 | ✅ DONE | `medical-health/DHS8_Mans/DHS8_Mans_QRE_EN_03Feb2023_DHSQ8.pdf` |
| 24 | ✅ DONE | `education-psychology/TIMSS_2019_Grade4/TIMSS_2019_Student_4.pdf` |
| 27 | ✅ DONE | `legal-regulatory/FTC_Model_Second_Request_2024.pdf` |
| 28 | ✅ DONE | `education-psychology/TIMSS_2019_Grade8/TIMSS_2019_Student_IntSci_8.pdf` |
| 30 | ✅ DONE (was has_ocr) | `census-demographics/LFS_Labour_Force/LFS_Labour_Force.pdf` |
| 31 | ✅ DONE | `infrastructure-inspection/InterNACHI Home Inspection Checklist 5.pdf` |
| 31 | ✅ DONE | `legal-regulatory/EPA_RCRA_LQG_Checklist.pdf` |
| 32 | ✅ DONE | `census-demographics/UK_Census_2021/UK_Census_2021_Household_England.pdf` |
| 33 | ✅ DONE (was has_ocr) | `sociology/GSS_Time_Use/GSS_Time_Use.pdf` |
| 35 | ✅ DONE | `education-psychology/PISA_2012_School/PISA_2012_School.pdf` |
| 36 | ✅ DONE 📚 | `safety-critical/IAEA_TECDOC_1321.pdf` |
| 39 | ✅ DONE | `education-psychology/PISA_2012_Student/PISA_2012_Student_FormA.pdf` |
| 40 | ✅ DONE | `sociology/LAPOP_2021/LAPOP_2021_Core.pdf` |
| 40 | ✅ DONE (1 pdftotext fb) | `compliance-risk/PCI_DSS_SAQ_A/PCI_DSS_v4_SAQ_A.pdf` |
| 41 | ✅ DONE | `medical-health/AUDIT_Alcohol/AUDIT.pdf` |
| 42 | ✅ DONE | `compliance-risk/ISO_9001_Audit/ISO_9001_Mock_Audit.pdf` |
| 45 | ✅ DONE (23 pdftotext fb) 📚 | `safety-critical/OSHA_PSM_Guidelines.pdf` |
| 47 | ✅ DONE | `compliance-risk/CISA_Vendor_SCRM/Vendor_SCRM_Template.pdf` |
| 49 | ✅ DONE (was has_ocr) | `education-psychology/SAEP_Education_Planning/SAEP_Education_Planning.pdf` |
| 58 | ✅ DONE (was has_ocr) | `medical-health/PALS_Activity_Limitation/PALS_Activity_Limitation.pdf` |
| 60 | ✅ DONE (was has_ocr) | `census-demographics/SLID_Labour_Income/SLID_Labour_Income.pdf` |
| 65 | ✅ DONE (was has_ocr) | `census-demographics/SHS_2000_Household_Spending/SHS_2000_Household_Spending.pdf` |
| 66 | ✅ DONE | `medical-health/ICS_kerdezesi_protokoll/ICS_kerdezesi_protokoll_v2.0_2023.12.19.pdf` |
| 66 | ✅ DONE | `medical-health/NPHS_Population_Health/NPHS_Population_Health.pdf` |
| 71 | ✅ DONE | `medical-health/DHS8_Womans/DHS8_Womans_QRE_EN_14Feb2023_DHSQ8.pdf` |
| 93 | ✅ DONE | `sociology/Arab_Barometer_VIII/Arab_Barometer_VIII.pdf` |
| 97 | ✅ DONE 📚 | `infrastructure-inspection/AWS_Well_Architected_Framework.pdf` |
| 105 | ✅ DONE | `sociology/ESS12/ESS12-source-questionnaire.pdf` |
| 115 | ✅ DONE | `safety-critical/FEMA_ICS_Forms_Booklet.pdf` |
| 118 | ✅ DONE | `compliance-risk/PCI_DSS_SAQ_D_Merchant/PCI_DSS_v4_SAQ_D_Merchant.pdf` |
| 124 | ✅ DONE 📚 | `infrastructure-inspection/FHWA_Bridge_Inspection_Guide.pdf` |
| 127 | ✅ DONE (was has_ocr) | `medical-health/BRFSS_2023/BRFSS_2023.pdf` |
| 131 | ✅ DONE (1 pdftotext fb) 📚 | `safety-critical/IAEA_TECDOC_1125.pdf` |
| 140 | ✅ DONE | `sociology/SHARE_Wave9/SHARE_Wave9.pdf` |
| 158 | ✅ DONE (was has_ocr) | `sociology/GSS_1999_Victimization/GSS_1999_Victimization.pdf` |
| 244 | ✅ DONE (was has_ocr) | `sociology/NLSCY_Children_Youth/NLSCY_Children_Youth.pdf` |
| 303 | ✅ DONE (was has_ocr) | `medical-health/CCHS_2005_Health/CCHS_2005_Health.pdf` |
| 309 | ✅ DONE (was DEFERRED) | `sociology/GSS_2024/GSS2024_Ballot1.pdf` |
| 733 | ✅ DONE (was DEFERRED) | `compliance-risk/NIST_CSF/NIST_SP_800_53A_Assessment.pdf` |
| 1017 | ✅ DONE (was DEFERRED) | `medical-health/NHIS_2024.pdf` |

## Notes

- Legacy `_ocr.md` (pdftotext) and `_docling.md` (Docling) files are kept alongside the source as benchmark references; they are not deleted when a fresh `_text.md` is produced.
- `has_ocr` files already have a usable text intermediate from the legacy pipeline. Regenerating `_text.md` via Sonnet is useful for quality comparison but is not blocking downstream inventory / QML / analysis work. They are a candidate for a follow-up batch (~12 files, 1161 pages, ~$11).
- Three `DEFERRED` files (>150 pages) are large enough that the cumulative cost (~$20) warrants explicit approval before running.
- Five files used the new `pdftotext` fallback for at least one page where Bedrock's model-baked content filter refused output. The fallback now lives in `askalot_inventory/parse/claude_vision.py::_pdftotext_page_fallback` and triggers automatically — no manual intervention needed for future runs.
