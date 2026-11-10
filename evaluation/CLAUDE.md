# Evaluation corpus

One folder per instrument, `evaluation/<domain>/<NAME>/`, holding the blank source and what was made from it.

## Source and text

| File | Content |
|---|---|
| `<NAME>.pdf` | the blank source instrument |
| `<NAME>_text.md` | text extraction by the `askalot-inventory` preprocessor (see `_extraction_status.md`) |
| `<NAME>_ocr.md`, `<NAME>_docling.md` | legacy extractions, kept as benchmarks |

## Imported by Askalot (questionnaire import, askalot#1972)

An instrument converted through Askalot's questionnaire import keeps what the import produces, in its order (PDF → Markdown → inventory → QML):

| File | Content |
|---|---|
| `<NAME>.md` | the source as the import read it: Markdown with YAML front matter (source file, page count, pages read by vision, what the normalizer removed), each page behind a marker `<!-- page N printed="…" read_by="…" -->`; running headers, footers and printed page numbers removed, answers stripped |
| `<NAME>.inventory.json` | the inventory (`inventory/v1`): questions with printed ids, checks (invented ones marked), scope, resolved jumps; its `page` fields are the markers' `N` |
| `<NAME>.qml` | the imported questionnaire, version 1 as stored by the import |

A report of an import, when one is kept, is `report_<NAME>.md`.

## Converted by hand (earlier skills)

Instruments converted before the import keep `<NAME>.qml`, `<NAME>_question_inventory.md` and a conversion report named `<NAME>.md` (in those folders `<NAME>.md` is the report, not the source).
