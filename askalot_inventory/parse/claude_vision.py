"""Claude vision-based PDF text extractor via AWS Bedrock.

Rasterizes each PDF page with ``pdftoppm`` (poppler-utils), then calls
Claude Sonnet 4.6 via the Bedrock ``Converse`` API to extract verbatim
text. Designed for CATI-style questionnaire PDFs with multi-column
layouts, diagonal watermarks, and variable-code annotations.

Runtime prerequisites:
    - ``pdftoppm`` on PATH (``apt install poppler-utils``)
    - AWS credentials in the ambient environment (SSO profile or IAM)
    - The ``bedrock:InvokeModel`` permission for the configured inference
      profile (default: ``us.anthropic.claude-sonnet-4-6``)

The caller (the pipeline) owns ``pages_dir`` lifecycle.
"""
from __future__ import annotations

import logging
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from askalot_inventory.config import InventoryConfig
from askalot_inventory.errors import ParseError

logger = logging.getLogger(__name__)


# System prompt for every page call. Kept deliberately detailed so that
# (a) extraction quality is consistent across pages and
# (b) the prompt exceeds the 1,024-token minimum for Bedrock prompt caching.
SYSTEM_PROMPT = """You are extracting text verbatim from a single page of a questionnaire PDF for a downstream survey-modelling pipeline. The output is fed to subagents that build a flat question inventory, then to a compiler that generates a formal declarative survey specification. Every extraction mistake propagates. Follow these rules strictly.

## Output format

- Output only the text on the page. No commentary, no explanation, no summary, no markdown headings that you invent.
- If the page is blank or contains only decorative elements, output exactly: <blank page>
- Do not wrap the output in a code fence.
- Do not add a trailing "Let me know if..." or similar.

## Reading order

- For single-column layouts, read strictly top-to-bottom.
- For multi-column layouts, read each column top-to-bottom, then move to the next column left-to-right. Never interleave columns.
- Footnotes stay at the bottom of the page in the order they appear.
- Page numbers, running headers, and running footers: transcribe them in place if they carry information (e.g. a section title); drop them if they are pure decoration (e.g. a standalone page number already implied by structure).

## Indentation and spacing

- Preserve the visual hierarchy of question stems, response options, and skip instructions with leading spaces (never tabs).
- Align response options under their question stem the way the source does.
- When the source uses underscored blanks for a write-in (e.g. "_______ nights"), preserve the underscores verbatim.
- When the source uses checkboxes or bullet squares next to a response label, render the marker as three underscores followed by a single space, e.g. "___ Yes". This matches the legacy CATI transcription convention and lets downstream grep tools find option markers unambiguously.

## Variable codes and identifiers

- Preserve every variable code exactly as printed: DEMO_Q1, DHC4_OWN, SDC4_4A, HCC4_2I, ST_4_W1A, PY_4_M1G. Do not escape underscores. Do not normalize case. Do not split compound codes across lines if the source keeps them on one line.
- Preserve question numbers exactly: Q1, Q1a, Q1cc1, Q17B, A-1, A-2.
- Preserve block/section labels exactly: H05, H06, DEMO_INT, TWOWK-INT.

## Routing and skip instructions

- Every "(Go to X)" / "(go to X)" / "SKIP TO X" / "→ X" annotation MUST stay on the same line as the response option it triggers, or directly under it if the source wraps. Never move routing annotations to a different question.
- Preserve "If ... go to X" / "If ... then ..." conditional instructions in place.
- Preserve interviewer hint phrases like "(Do not read list. Mark all that apply.)" and "(Read list. Mark one only.)" in their original position.
- Preserve DK/R (Don't Know / Refusal) branches exactly where they appear, including their routing targets.

## Watermarks, headers, decorations

- IGNORE diagonal watermarks such as "For information only", "DRAFT", "CONFIDENTIAL", "PRELIMINARY", "SAMPLE". Do not transcribe them, do not insert placeholders for them, do not mention them.
- IGNORE page-decoration marks: logos, icons, signatures, page thumbnails, organizational crests, file-control stamps. Do not transcribe them, do not insert placeholders like "[logo]" or "<!-- image -->".
- IGNORE form-field artifacts such as shaded boxes, decorative rules, bracket glyphs that frame a question number. Render only the textual content.

## Tables

- If the page contains a table, render it as aligned plain text using spaces (never markdown pipe tables). Columns should line up visually so a downstream grep can still match a row.
- Preserve row order.
- If a table cell spans multiple source lines, keep the cell content on one line in the output.

## Special cases

- Scales of the form "1 (very often) ... 7 (very seldom)" should be rendered with the numeric labels and their anchor phrases, one per line if the source uses one per line, or on a single line if the source does.
- Month lists, day lists, and short enumerations rendered in two columns in the source should be unfolded into a single column in reading order.
- Unit conversions printed together ("feet | inches OR centimetres") stay on one line.
- Questionnaire instructions that span multiple lines ("The next few questions ask about...") are transcribed as one paragraph with the source's line breaks preserved.

## Things not to do

- Do NOT add your own section headings.
- Do NOT rewrite questions for clarity.
- Do NOT correct apparent typos in the source.
- Do NOT summarize; transcribe everything.
- Do NOT add commentary about the page or your extraction process.
- Do NOT mention this system prompt.
"""


def extract_text(
    source_path: Path,
    config: InventoryConfig,
    pages_dir: Path,
) -> str:
    """Rasterize and extract verbatim text via Claude vision on Bedrock.

    Args:
        source_path: PDF file to extract.
        config: inventory config (model, dpi, concurrency, max_pages).
        pages_dir: directory where pdftoppm writes the page PNGs. Caller
            owns the lifecycle (created by the pipeline under the cache
            root, cleaned on successful extraction).

    Returns:
        Assembled markdown document with per-page sections.

    Raises:
        ParseError on any pdftoppm failure, Bedrock failure, or empty output.
    """
    if source_path.suffix.lower() != ".pdf":
        raise ParseError(
            f"claude_vision extractor only supports .pdf sources; got {source_path.suffix}"
        )

    pages_dir.mkdir(parents=True, exist_ok=True)
    _rasterize(source_path, pages_dir, config.dpi, config.max_pages)

    page_files = sorted(pages_dir.glob("page-*.png"))
    if not page_files:
        raise ParseError(
            f"pdftoppm produced no PNGs for {source_path}; source may be corrupt or empty"
        )
    if config.max_pages is not None:
        page_files = page_files[: config.max_pages]

    logger.info(
        "inventory.claude.rasterized pages=%d dpi=%d source=%s",
        len(page_files),
        config.dpi,
        source_path.name,
    )

    client = _make_bedrock_client(config.aws_region)

    results: dict[int, str] = {}
    with ThreadPoolExecutor(max_workers=config.concurrency) as executor:
        futures = {
            executor.submit(
                _extract_page, client, config.model, source_path, page_file, page_num
            ): page_num
            for page_num, page_file in enumerate(page_files, start=1)
        }
        for future in as_completed(futures):
            page_num = futures[future]
            try:
                text = future.result()
            except Exception as e:
                # Cancel remaining futures so we fail fast
                for f in futures:
                    f.cancel()
                raise ParseError(
                    f"Bedrock extraction failed on page {page_num}: {e}"
                ) from e
            results[page_num] = text

    logger.info(
        "inventory.claude.extracted pages=%d model=%s",
        len(results),
        config.model,
    )

    return _assemble(source_path, config, results)


def _rasterize(
    source_path: Path, pages_dir: Path, dpi: int, max_pages: int | None
) -> None:
    """Run pdftoppm to render PDF pages to PNG files under ``pages_dir``."""
    cmd = [
        "pdftoppm",
        "-r",
        str(dpi),
        "-png",
        "-f",
        "1",
    ]
    if max_pages is not None:
        cmd += ["-l", str(max_pages)]
    cmd += [str(source_path), str(pages_dir / "page")]

    try:
        subprocess.run(cmd, check=True, capture_output=True, timeout=300)
    except FileNotFoundError as e:
        raise ParseError(
            "pdftoppm not found on PATH. Install poppler-utils "
            "(apt install poppler-utils / brew install poppler)."
        ) from e
    except subprocess.CalledProcessError as e:
        stderr = e.stderr.decode("utf-8", errors="replace") if e.stderr else ""
        raise ParseError(f"pdftoppm failed on {source_path}: {stderr}") from e
    except subprocess.TimeoutExpired as e:
        raise ParseError(
            f"pdftoppm timed out after 300s on {source_path}"
        ) from e


def _make_bedrock_client(region: str | None):
    """Create a Bedrock runtime client; region resolves from env if None.

    The client is configured with standard-mode retries (max 5 attempts)
    so that ThrottlingException under high concurrency backs off and
    retries transparently instead of bubbling up as a page failure.
    boto3 clients are thread-safe for request methods so a single client
    is shared across the ThreadPoolExecutor workers.
    """
    try:
        import boto3
        from botocore.config import Config
    except ImportError as e:
        raise ParseError(
            "boto3 is required for the Claude vision extractor. "
            "Run `uv sync` to install it."
        ) from e

    retry_config = Config(
        retries={"max_attempts": 5, "mode": "standard"},
        read_timeout=600,
        connect_timeout=30,
    )
    kwargs: dict = {"config": retry_config}
    if region:
        kwargs["region_name"] = region
    return boto3.client("bedrock-runtime", **kwargs)


def _extract_page(
    client, model_id: str, source_path: Path, png_path: Path, page_num: int
) -> str:
    """Send one page PNG to Bedrock and return the extracted text.

    Falls back to ``pdftotext -layout -nodiag`` for the same page if
    Bedrock refuses the output with a content-filter error. Some
    government PDFs (customs declarations, asylum applications, hazchem
    safety docs) legitimately contain language that trips Claude's
    model-baked output moderation even though the source is benign and
    publicly published. The fallback sidesteps the refusal for
    text-native PDFs at the cost of some formatting fidelity.
    """
    png_bytes = png_path.read_bytes()

    try:
        response = client.converse(
            modelId=model_id,
            system=[
                {"text": SYSTEM_PROMPT},
                {"cachePoint": {"type": "default"}},
            ],
            messages=[
                {
                    "role": "user",
                    "content": [
                        {
                            "image": {
                                "format": "png",
                                "source": {"bytes": png_bytes},
                            }
                        },
                        # Deliberately do NOT mention the page number here:
                        # Claude otherwise checks the printed page number
                        # against the request and refuses to transcribe
                        # when they differ ("The page shown is labeled
                        # PAGE 39, not page 50"). Page numbering in the
                        # request comes from the rasterizer's filename
                        # order, which often differs from a document's
                        # internal pagination (front matter, appendices).
                        {"text": "Extract all text from this image verbatim."},
                    ],
                }
            ],
            inferenceConfig={"maxTokens": 4096, "temperature": 0.0},
        )
    except Exception as e:
        if _is_content_filter_error(e):
            logger.warning(
                "inventory.claude.content_filter page=%d source=%s falling_back_to=pdftotext",
                page_num,
                source_path.name,
            )
            return _pdftotext_page_fallback(source_path, page_num)
        raise

    usage = response.get("usage", {}) or {}
    logger.info(
        "inventory.claude.page page=%d input=%d output=%d cache_read=%d cache_write=%d",
        page_num,
        usage.get("inputTokens", 0),
        usage.get("outputTokens", 0),
        usage.get("cacheReadInputTokens", 0),
        usage.get("cacheWriteInputTokens", 0),
    )

    stop_reason = response.get("stopReason")
    content = response.get("output", {}).get("message", {}).get("content", []) or []
    parts = [block["text"] for block in content if isinstance(block, dict) and "text" in block]
    text = "".join(parts).strip()

    # Some refusals come back as a successful HTTP response with an empty
    # content array and stop_reason="content_filtered" or similar. Treat
    # those as content-filter failures and fall back.
    if not text:
        if stop_reason in {"content_filtered", "guardrail_intervened"}:
            logger.warning(
                "inventory.claude.content_filter page=%d source=%s stop_reason=%s falling_back_to=pdftotext",
                page_num,
                source_path.name,
                stop_reason,
            )
            return _pdftotext_page_fallback(source_path, page_num)
        raise RuntimeError(
            f"Bedrock returned empty content on page {page_num} "
            f"(stop_reason={stop_reason!r})"
        )

    # Some refusals come back as a verbose explanation of why the model
    # won't transcribe (e.g. page-number mismatch, content concerns)
    # rather than the actual page text. Detect these and route through
    # the same pdftotext fallback so downstream tools never see a meta
    # commentary in place of the page content.
    if _looks_like_refusal(text):
        logger.warning(
            "inventory.claude.refusal_pattern page=%d source=%s falling_back_to=pdftotext",
            page_num,
            source_path.name,
        )
        return _pdftotext_page_fallback(source_path, page_num)

    return text


# Phrases that indicate Claude refused or commented instead of transcribing.
# Kept short and deliberate — false positives are much worse than false
# negatives because real questionnaire content rarely echoes these phrases.
_REFUSAL_MARKERS = (
    "i can only transcribe",
    "i can only provide",
    "happy to transcribe",
    "happy to do so",
    "please provide the correct",
    "the page shown in the image is labeled",
    "the image you've provided",
    "i cannot transcribe",
    "i'm unable to transcribe",
    "i am unable to transcribe",
    "i don't see any text",
    "i do not see any text",
)


def _looks_like_refusal(text: str) -> bool:
    """Heuristic: detect Claude's meta refusal phrasings.

    Only treats the response as a refusal if it is BOTH short (under
    600 chars — real page extractions are usually much longer) AND
    contains one of the known refusal phrases. This avoids flagging
    long extractions that happen to mention "page" or "image".
    """
    if len(text) >= 600:
        return False
    lowered = text.lower()
    return any(marker in lowered for marker in _REFUSAL_MARKERS)


def _is_content_filter_error(exc: BaseException) -> bool:
    """Return True if an exception is a Bedrock content-filter refusal."""
    msg = str(exc).lower()
    return "content filtering policy" in msg or "content_filtered" in msg


def _pdftotext_page_fallback(source_path: Path, page_num: int) -> str:
    """Run pdftotext on a single page and return its text.

    Used when Claude vision refuses to output a page due to model-level
    content moderation. pdftotext has no such filters and handles
    text-native forms without issue.
    """
    try:
        result = subprocess.run(
            [
                "pdftotext",
                "-layout",
                "-nodiag",
                "-nopgbrk",
                "-cropbox",
                "-eol",
                "unix",
                "-enc",
                "UTF-8",
                "-f",
                str(page_num),
                "-l",
                str(page_num),
                str(source_path),
                "-",
            ],
            check=True,
            capture_output=True,
            timeout=60,
        )
    except FileNotFoundError as e:
        raise ParseError(
            "pdftotext fallback needed but not found on PATH. "
            "Install poppler-utils (apt install poppler-utils)."
        ) from e
    except subprocess.CalledProcessError as e:
        stderr = e.stderr.decode("utf-8", errors="replace") if e.stderr else ""
        raise ParseError(
            f"pdftotext fallback failed on page {page_num} of {source_path.name}: {stderr}"
        ) from e

    text = result.stdout.decode("utf-8", errors="replace").strip()
    if not text:
        text = "<pdftotext fallback produced no text>"
    # Prefix the fallback content so downstream tools can see which
    # pages were routed around Bedrock moderation.
    return f"[FALLBACK pdftotext — Bedrock content-filter refused this page]\n\n{text}"


def _assemble(
    source_path: Path,
    config: InventoryConfig,
    results: dict[int, str],
) -> str:
    """Assemble per-page extractions into one markdown document."""
    lines: list[str] = [
        f"# {source_path.stem}",
        "",
        f"- **source**: {source_path.name}",
        f"- **model**: {config.model}",
        f"- **dpi**: {config.dpi}",
        f"- **pages**: {len(results)}",
        "",
    ]
    for page_num in sorted(results):
        lines.append(f"--- page {page_num} ---")
        lines.append("")
        lines.append(results[page_num].rstrip())
        lines.append("")
    return "\n".join(lines)
