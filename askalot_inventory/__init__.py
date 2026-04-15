"""Claude-vision preprocessor that turns questionnaire PDFs into a
plain-text markdown intermediate the `build-inventory` skill can parse.

The package rasterizes each page of the source PDF with ``pdftoppm`` and
extracts verbatim text via Claude Sonnet 4.6 vision on AWS Bedrock. The
result is cached by content hash and written as ``<stem>_text.md`` next
to the source document. All downstream inventory work happens in the
`build-inventory` skill, not here.
"""

from askalot_inventory.config import InventoryConfig
from askalot_inventory.errors import InventoryError, ParseError

__all__ = ["InventoryConfig", "InventoryError", "ParseError"]
