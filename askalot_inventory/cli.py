"""Command-line entry point: ``askalot-inventory <source>``.

Extracts verbatim text from a PDF questionnaire using Claude Sonnet 4.6
vision on AWS Bedrock. Produces ``<stem>_text.md`` next to the source.
The ``build-inventory`` skill then reads that intermediate.
"""
from __future__ import annotations

import argparse
import json
import logging
import sys
from pathlib import Path

from askalot_inventory.config import InventoryConfig, add_cli_arguments
from askalot_inventory.errors import InventoryError
from askalot_inventory.pipeline import run_pipeline


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="askalot-inventory",
        description=(
            "Extract verbatim text from a PDF questionnaire via Claude "
            "Sonnet 4.6 vision on AWS Bedrock. Each page is rasterized "
            "with pdftoppm and sent in parallel through the Bedrock "
            "Converse API with a cached system prompt. Output is "
            "assembled into <stem>_text.md next to the source, cached by "
            "SHA-256 of the input. Requires poppler-utils on PATH and "
            "AWS credentials in the ambient environment."
        ),
    )
    parser.add_argument("source", type=Path, help="Path to the PDF source")
    parser.add_argument(
        "--json",
        dest="json_report",
        action="store_true",
        help="Print a JSON summary to stdout instead of the text-md path",
    )
    add_cli_arguments(parser)
    return parser


def _configure_logging(level: str) -> None:
    logging.basicConfig(
        level=level.upper(),
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
    )


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    source_path = args.source.expanduser().resolve()
    if not source_path.is_file():
        print(f"error: source not found: {source_path}", file=sys.stderr)
        return 2

    config = InventoryConfig.from_env(source_path).merge_cli(args)
    _configure_logging(config.log_level)

    try:
        result = run_pipeline(config)
    except InventoryError as e:
        print(f"error: {e}", file=sys.stderr)
        return 2

    if args.json_report:
        payload = {
            "source": str(result.source_path),
            "cache_dir": str(result.cache_dir),
            "cache_hit": result.cache_hit,
            "text": str(result.text_path),
            "output_text": str(result.output_text_path)
            if result.output_text_path
            else None,
            "page_count": result.page_count,
            "model": config.model,
            "dpi": config.dpi,
        }
        print(json.dumps(payload, indent=2))
    else:
        print(str(result.output_text_path or result.text_path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
