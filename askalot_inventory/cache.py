"""SHA-256 content-hash cache for the inventory text extractor.

Layout::

    <cache_dir>/<sha256[:16]>/
        source.sha256    # full hex digest
        text.md          # Claude-vision extracted text

The cache is per-source-file. Any change to the source produces a new
directory. Transient page PNGs used during rasterization live in a
tempdir owned by the pipeline, not in the cache.
"""
from __future__ import annotations

import logging
from pathlib import Path

logger = logging.getLogger(__name__)


class InventoryCache:
    """Filesystem cache keyed by source document SHA-256."""

    def __init__(
        self, cache_root: Path, source_sha256: str, *, skip: bool = False
    ) -> None:
        self._root = cache_root / source_sha256[:16]
        self._source_sha256 = source_sha256
        self._skip = skip
        if not skip:
            self._root.mkdir(parents=True, exist_ok=True)
            (self._root / "source.sha256").write_text(source_sha256, encoding="utf-8")

    @property
    def root(self) -> Path:
        return self._root

    @property
    def skip(self) -> bool:
        return self._skip

    def text_path(self) -> Path:
        return self._root / "text.md"

    def load_text(self) -> str | None:
        if self._skip:
            return None
        p = self.text_path()
        if p.exists():
            logger.info(
                "inventory.cache.hit hash=%s", self._source_sha256[:16]
            )
            return p.read_text(encoding="utf-8")
        return None

    def save_text(self, text: str) -> None:
        if self._skip:
            return
        self.text_path().write_text(text, encoding="utf-8")
