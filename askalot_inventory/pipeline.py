"""Claude-vision preprocessor pipeline.

Input: a PDF source document.
Output: a :class:`PipelineResult` containing the cache directory, the
extracted text markdown path, and an optional output-directory copy
written next to the source.
"""
from __future__ import annotations

import logging
import tempfile
from dataclasses import dataclass
from pathlib import Path

from askalot_inventory.cache import InventoryCache
from askalot_inventory.config import InventoryConfig
from askalot_inventory.errors import ParseError
from askalot_inventory.parse.claude_vision import extract_text
from askalot_inventory.parse.pdf_hash import sha256_file

logger = logging.getLogger(__name__)


@dataclass
class PipelineResult:
    source_path: Path
    cache_dir: Path
    text_path: Path
    output_text_path: Path | None
    page_count: int
    cache_hit: bool


def _write_to_output_dir(config: InventoryConfig, text: str) -> Path | None:
    """Write the extracted text next to the source (or to --output-dir).

    Takes the in-memory text directly so the write is correct under
    ``--skip-cache`` when the cache file does not exist.
    """
    target_dir: Path = (
        config.output_dir
        if config.output_dir is not None
        else config.source_path.parent
    )
    target_dir.mkdir(parents=True, exist_ok=True)
    stem = config.source_path.stem

    text_target = target_dir / f"{stem}_text.md"
    text_target.write_text(text, encoding="utf-8")
    return text_target


def _count_pages(text: str) -> int:
    """Count '--- page N ---' separators in an assembled extraction."""
    count = 0
    for line in text.splitlines():
        if line.startswith("--- page ") and line.endswith(" ---"):
            count += 1
    return count


def run_pipeline(config: InventoryConfig) -> PipelineResult:
    logger.info("inventory.pipeline.start source=%s", config.source_path)

    if config.source_path.suffix.lower() != ".pdf":
        raise ParseError(
            f"askalot-inventory only supports PDF sources; got "
            f"{config.source_path.suffix} for {config.source_path}"
        )

    source_sha = sha256_file(config.source_path)
    cache = InventoryCache(
        config.cache_dir, source_sha, skip=config.skip_cache
    )

    cached_text = cache.load_text()
    cache_hit = cached_text is not None

    if cache_hit:
        text = cached_text
        assert text is not None  # for type narrowing
    else:
        # Rasterize into a tempdir that is cleaned up unconditionally,
        # regardless of --skip-cache or cache write success.
        with tempfile.TemporaryDirectory(prefix="askalot-inventory-pages-") as tmp:
            text = extract_text(config.source_path, config, Path(tmp))
        cache.save_text(text)

    output_text_path = _write_to_output_dir(config, text)

    result = PipelineResult(
        source_path=config.source_path,
        cache_dir=cache.root,
        text_path=cache.text_path(),
        output_text_path=output_text_path,
        page_count=_count_pages(text),
        cache_hit=cache_hit,
    )
    logger.info(
        "inventory.pipeline.done cache_hit=%s pages=%d output=%s",
        cache_hit,
        result.page_count,
        output_text_path,
    )
    return result
