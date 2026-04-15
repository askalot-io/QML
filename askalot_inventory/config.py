"""Inventory preprocessor configuration.

Values resolve in precedence order: CLI flag > environment variable > default.
CLI flag names mirror the env-var names for discoverability.
"""
from __future__ import annotations

import argparse
import os
from dataclasses import dataclass, field, replace
from pathlib import Path
from typing import Any

ENV_PREFIX = "ASKALOT_INVENTORY_"

DEFAULT_CACHE_DIR = Path.home() / ".cache" / "askalot_qml" / "inventory"
DEFAULT_MODEL = "us.anthropic.claude-sonnet-4-6"
DEFAULT_DPI = 150
DEFAULT_CONCURRENCY = 8


def _env_bool(name: str, default: bool) -> bool:
    val = os.environ.get(name)
    if val is None:
        return default
    return val.strip().lower() in {"1", "true", "yes", "on"}


def _env_int(name: str, default: int) -> int:
    val = os.environ.get(name)
    if val is None:
        return default
    try:
        return int(val)
    except ValueError as e:
        raise ValueError(f"{name}={val!r} is not an integer") from e


def _env_optional_int(name: str) -> int | None:
    val = os.environ.get(name)
    if val is None:
        return None
    try:
        return int(val)
    except ValueError as e:
        raise ValueError(f"{name}={val!r} is not an integer") from e


def _env_path(name: str, default: Path) -> Path:
    val = os.environ.get(name)
    if val is None:
        return default
    return Path(val).expanduser()


def _env_optional_path(name: str) -> Path | None:
    val = os.environ.get(name)
    if val is None:
        return None
    return Path(val).expanduser()


def _env_str(name: str, default: str) -> str:
    return os.environ.get(name, default)


def _env_optional_str(name: str) -> str | None:
    val = os.environ.get(name)
    if val is None or val == "":
        return None
    return val


@dataclass(frozen=True)
class InventoryConfig:
    """All knobs for the Claude-vision preprocessor."""

    source_path: Path
    cache_dir: Path = field(default_factory=lambda: DEFAULT_CACHE_DIR)
    skip_cache: bool = False
    model: str = DEFAULT_MODEL
    dpi: int = DEFAULT_DPI
    concurrency: int = DEFAULT_CONCURRENCY
    max_pages: int | None = None
    aws_region: str | None = None
    output_dir: Path | None = None
    log_level: str = "INFO"

    @classmethod
    def from_env(cls, source_path: Path) -> InventoryConfig:
        return cls(
            source_path=source_path,
            cache_dir=_env_path(f"{ENV_PREFIX}CACHE_DIR", DEFAULT_CACHE_DIR),
            skip_cache=_env_bool(f"{ENV_PREFIX}SKIP_CACHE", False),
            model=_env_str(f"{ENV_PREFIX}MODEL", DEFAULT_MODEL),
            dpi=_env_int(f"{ENV_PREFIX}DPI", DEFAULT_DPI),
            concurrency=_env_int(f"{ENV_PREFIX}CONCURRENCY", DEFAULT_CONCURRENCY),
            max_pages=_env_optional_int(f"{ENV_PREFIX}MAX_PAGES"),
            aws_region=_env_optional_str(f"{ENV_PREFIX}AWS_REGION"),
            output_dir=_env_optional_path(f"{ENV_PREFIX}OUTPUT_DIR"),
            log_level=_env_str(f"{ENV_PREFIX}LOG_LEVEL", "INFO"),
        )

    def merge_cli(self, args: argparse.Namespace) -> InventoryConfig:
        overrides: dict[str, Any] = {}

        def _set(field_name: str, value: Any) -> None:
            if field_name in {"cache_dir", "output_dir"} and not isinstance(value, Path):
                value = Path(value).expanduser()
            overrides[field_name] = value

        mapping = {
            "cache_dir": "cache_dir",
            "skip_cache": "skip_cache",
            "model": "model",
            "dpi": "dpi",
            "concurrency": "concurrency",
            "max_pages": "max_pages",
            "aws_region": "aws_region",
            "output_dir": "output_dir",
            "log_level": "log_level",
        }
        for cli_name, field_name in mapping.items():
            val = getattr(args, cli_name, None)
            if val is None:
                continue
            _set(field_name, val)

        return replace(self, **overrides)


def add_cli_arguments(parser: argparse.ArgumentParser) -> None:
    """Attach preprocessor config flags to an argparse parser."""
    parser.add_argument("--cache-dir", default=None, help="Cache directory")
    parser.add_argument(
        "--skip-cache",
        action="store_true",
        default=None,
        help="Bypass the extraction cache",
    )
    parser.add_argument(
        "--model",
        default=None,
        help=f"Bedrock model/inference profile id (default: {DEFAULT_MODEL})",
    )
    parser.add_argument(
        "--dpi",
        type=int,
        default=None,
        help=f"Page rasterization DPI (default: {DEFAULT_DPI})",
    )
    parser.add_argument(
        "--concurrency",
        type=int,
        default=None,
        help=f"Parallel Bedrock calls (default: {DEFAULT_CONCURRENCY})",
    )
    parser.add_argument(
        "--max-pages",
        type=int,
        default=None,
        help="Only extract the first N pages (for iterative testing)",
    )
    parser.add_argument(
        "--aws-region",
        default=None,
        help="AWS region for the Bedrock client (default: from env)",
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Output directory for the intermediate (default: next to source)",
    )
    parser.add_argument(
        "--log-level",
        default=None,
        choices=["DEBUG", "INFO", "WARNING", "ERROR"],
        help="Log level",
    )
