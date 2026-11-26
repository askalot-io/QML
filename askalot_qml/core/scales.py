"""Declared rating scales: the structure of a scale and everything derived from it.

A Radio or Dropdown Question, QuestionGroup or MatrixQuestion may declare the
structure of its rating scale with one ``scale`` key on the Item::

    scale:
      polarity: bipolar        # bipolar or unipolar
      points: 5                # a whole number from 2 to 101
      start: 1                 # 0 or 1; 1 when left out
      order: descending        # display order; ascending when left out

This module is the only place that knows what a declaration means. Every other
reader (the loader, the validator, the walk, the measures, the exports, Gold)
asks it for the range, the midpoint, the sides and the display order, so no
other module computes any of them.

Decisions the rest of the platform relies on:

- **The module knows structure and nothing else.** It holds no label, no
  wording and no translation, and it never receives one: the author writes every
  label in ``input.labels``, and a verdict about a scale never depends on the
  language of the questionnaire.
- **Codes run from the negative or low end to the positive or high end.** The
  points are ``start`` to ``start + points - 1``. Coding the labels in that
  direction is the author's responsibility; nothing can check it without
  reading wording.
- **Codes never change meaning with display order.** A descending item shows
  the same codes from the highest to the lowest, so no analysis step ever
  reverses a code because of how an item was displayed.
- **Sides follow from polarity and point count.** A bipolar scale with an odd
  count has a midpoint, with the codes below it negative and the codes above it
  positive; an even bipolar scale splits in half and has no midpoint; a unipolar
  scale has neither a midpoint nor sides.
- **An out-of-scale answer is a labelled code above the range** ("Don't know"
  at 8 on a five-point scale). Nothing declares it: the author picks its code
  and wording. It counts as answered, and no measure reads its value. A code
  below ``start`` is not out of scale; the loader refuses it.
"""

from __future__ import annotations

from collections.abc import Iterable, Mapping
from dataclasses import dataclass

POLARITIES: tuple[str, ...] = ("bipolar", "unipolar")
STARTS: tuple[int, ...] = (0, 1)
ORDERS: tuple[str, ...] = ("ascending", "descending")
MIN_POINTS = 2
# A 0 to 100 scale is the widest in survey practice. The bound also keeps every
# structure derived from a declaration (the codes, the options) small.
MAX_POINTS = 101
# How many codes a refusal names before it counts the rest: a message about a
# document is never as long as the document.
NAMED_CODES = 8

_KEYS: tuple[str, ...] = ("polarity", "points", "start", "order")


class ScaleError(ValueError):
    """A ``scale`` declaration whose structure is not one the platform accepts."""


@dataclass(frozen=True)
class Scale:
    """A validated declaration. Build one with ``parse_scale``."""

    polarity: str
    points: int
    start: int = 1
    order: str = "ascending"

    @property
    def bipolar(self) -> bool:
        return self.polarity == "bipolar"

    @property
    def top(self) -> int:
        """The highest point's code."""
        return self.start + self.points - 1

    @property
    def point_codes(self) -> tuple[int, ...]:
        """The points' codes from the negative or low end to the positive or high end."""
        return tuple(range(self.start, self.top + 1))

    @property
    def midpoint(self) -> int | None:
        if self.bipolar and self.points % 2 == 1:
            return self.start + (self.points - 1) // 2
        return None

    @property
    def negative_codes(self) -> tuple[int, ...]:
        """The lower side of a bipolar scale (below the midpoint); empty for a unipolar one."""
        if not self.bipolar:
            return ()
        return self.point_codes[: self.points // 2]

    @property
    def positive_codes(self) -> tuple[int, ...]:
        """The upper side of a bipolar scale (above the midpoint); empty for a unipolar one."""
        if not self.bipolar:
            return ()
        return self.point_codes[self.points - self.points // 2 :]

    def out_of_scale(self, codes: Iterable[int]) -> tuple[int, ...]:
        """Those of ``codes`` that lie above the range, ascending."""
        return tuple(sorted({code for code in codes if code > self.top}))

    def display_order(self, codes: Iterable[int]) -> list[tuple[int, bool]]:
        """``(code, is_out_of_scale)`` as a respondent sees them: the points as declared, then the rest of ``codes`` above the range, ascending."""
        points = list(self.point_codes)
        if self.order == "descending":
            points.reverse()
        return [(code, False) for code in points] + [(code, True) for code in self.out_of_scale(codes)]

    def as_dict(self) -> dict:
        """The declaration as QML spells it, every key present."""
        return {
            "polarity": self.polarity,
            "points": self.points,
            "start": self.start,
            "order": self.order,
        }


def name_codes(codes: Iterable[object]) -> str:
    """``codes`` as a refusal names them: the first ``NAMED_CODES``, then how many more there are."""
    codes = list(codes)
    named = ", ".join(str(code) for code in codes[:NAMED_CODES])
    rest = len(codes) - NAMED_CODES
    return f"{named} and {rest} more" if rest > 0 else named


def parse_scale(raw: Mapping) -> Scale:
    """Validate one ``scale`` mapping and return it; raise ``ScaleError`` naming what is allowed."""
    if not isinstance(raw, Mapping):
        raise ScaleError("scale must be a mapping with polarity and points")
    unknown = [str(key) for key in raw if key not in _KEYS]
    if unknown:
        raise ScaleError(
            f"scale has no key {', '.join(repr(key) for key in unknown)}; its keys are {', '.join(_KEYS)}"
        )
    polarity = raw.get("polarity")
    if polarity is None:
        raise ScaleError("scale needs a polarity: bipolar or unipolar")
    if polarity not in POLARITIES:
        raise ScaleError(f"scale polarity is bipolar or unipolar, not {polarity!r}")
    points = raw.get("points")
    if points is None:
        raise ScaleError("scale needs its number of points")
    if isinstance(points, bool) or not isinstance(points, int) or not MIN_POINTS <= points <= MAX_POINTS:
        raise ScaleError(f"scale points is a whole number from {MIN_POINTS} to {MAX_POINTS}, not {points!r}")
    start = raw.get("start", 1)
    # ``1.0 in (0, 1)`` is true, so the type is checked before the membership.
    if isinstance(start, bool) or not isinstance(start, int) or start not in STARTS:
        raise ScaleError(f"scale start is 0 or 1, not {start!r}")
    order = raw.get("order", "ascending")
    if order not in ORDERS:
        raise ScaleError(f"scale order is ascending or descending, not {order!r}")
    return Scale(polarity=polarity, points=points, start=start, order=order)
