"""Exception types for the inventory preprocessor."""


class InventoryError(Exception):
    """Base class for inventory preprocessor errors."""


class ParseError(InventoryError):
    """The extractor failed to parse the source document."""
