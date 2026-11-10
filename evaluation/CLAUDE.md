# Evaluation corpus

One folder per instrument, `evaluation/<domain>/<NAME>/`, holding the blank source and what was made from it. The source catalog (provenance, download links) is [`questionnaire_sources.md`](questionnaire_sources.md).

New conversions go through Askalot's questionnaire import, in the product or through the askalot-plugin / Askalot MCP server (see the root [README](../README.md#converting-a-questionnaire-into-qml)). This repository has no conversion pipeline of its own.

## Imported by Askalot (questionnaire import)

An instrument converted through the import keeps what the import produces, in its order (PDF → Markdown → inventory → QML):

| File | Content |
|---|---|
| `<NAME>.pdf` | the blank source instrument |
| `<NAME>.md` | the source as the import read it: Markdown with YAML front matter (source file, page count, pages read by vision, what the normalizer removed), each page behind a marker `<!-- page N printed="…" read_by="…" -->`; running headers, footers and printed page numbers removed, answers stripped |
| `<NAME>.inventory.json` | the inventory (`inventory/v1`): questions with printed ids, checks (invented ones marked), scope, resolved jumps; its `page` fields are the markers' `N` |
| `<NAME>.qml` | the imported questionnaire, version 1 as stored by the import |

A report of an import, when one is kept, is `report_<NAME>.md`.

Imported so far: ACS 2025, BRFSS 2023, ESS12, GSS 1999 Victimization, GSS Time Use, LFS, NLSCY, NPHS, PALS, SAEP, SHS 2000, SLID.

## Other folders

CCHS 2005 Health is the one instrument converted before the import existed and kept as it was: `<NAME>.qml`, `<NAME>_question_inventory.md` and a conversion report named `<NAME>.md` (there `<NAME>.md` is the report, not the source). At 303 pages it is over the import's 300-page limit. Every other folder holds only its source files, waiting for an import.
