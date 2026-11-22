"""Declared rating scales: the families, their point counts, opt-outs and expansion.

A Radio or Dropdown Question, QuestionGroup or MatrixQuestion may declare its
rating scale with one ``scale`` key on the Item::

    scale:
      family: Agreement        # one of FAMILIES
      points: 5                # 4, 5 or 7
      order: descending        # display order; ascending by default
      optOuts: [dontKnow]      # any of dontKnow, notApplicable, preferNotToSay

This module is the only place that knows what a declaration means. Every other
reader (the loader, the validator, the walk, the measures, the exports, Gold)
asks it for codes and labels, so a family's codes have one definition.

Decisions the rest of the platform relies on:

- **Codes never change meaning.** The points are coded 1 to N from the most
  negative or least point to the most positive or greatest, whatever the display
  order. A descending item shows the same codes in reverse, so no analysis step
  ever reverses a code because of how an item was displayed.
- **A bipolar family has a midpoint exactly when its point count is odd**; a
  unipolar family never has one. One rule, instead of a declared midpoint.
- **Opt-outs sit at reserved codes outside the points** (97 don't know, 98 not
  applicable, 99 prefer not to say) and are always shown after the points. Two
  digit positive codes follow survey convention and survive the SPSS exporter's
  numeric value-label cast. An opt-out counts as answered, but no measure reads
  its value; readers mask it.
- **Labels are gettext msgids** in askalot_qml's catalog. The catalog has no
  message context, so no English label is shared by two families: a target
  language may need different words for the same English (``test_scales``
  holds this).
"""

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass

from askalot_common.i18n import N_, gettext

POINT_COUNTS: tuple[int, ...] = (4, 5, 7)
ORDERS: tuple[str, ...] = ("ascending", "descending")

# Opt-out name -> (reserved code, label msgid), in the order they are shown.
OPT_OUTS: dict[str, tuple[int, str]] = {
    "dontKnow": (97, N_("Don't know")),
    "notApplicable": (98, N_("Does not apply to me")),
    "preferNotToSay": (99, N_("Prefer not to say")),
}


class ScaleError(ValueError):
    """A ``scale`` declaration that names something the catalog does not have."""


@dataclass(frozen=True)
class Family:
    """One scale family: its polarity and its labels for each point count, codes 1..N in order."""

    bipolar: bool
    labels: Mapping[int, tuple[str, ...]]


FAMILIES: dict[str, Family] = {
    "Agreement": Family(
        bipolar=True,
        labels={
            4: (N_("Strongly disagree"), N_("Disagree"), N_("Agree"), N_("Strongly agree")),
            5: (
                N_("Strongly disagree"),
                N_("Disagree"),
                N_("Neither agree nor disagree"),
                N_("Agree"),
                N_("Strongly agree"),
            ),
            7: (
                N_("Strongly disagree"),
                N_("Disagree"),
                N_("Somewhat disagree"),
                N_("Neither agree nor disagree"),
                N_("Somewhat agree"),
                N_("Agree"),
                N_("Strongly agree"),
            ),
        },
    ),
    "Satisfaction": Family(
        bipolar=True,
        labels={
            4: (N_("Very dissatisfied"), N_("Dissatisfied"), N_("Satisfied"), N_("Very satisfied")),
            5: (
                N_("Very dissatisfied"),
                N_("Dissatisfied"),
                N_("Neither satisfied nor dissatisfied"),
                N_("Satisfied"),
                N_("Very satisfied"),
            ),
            7: (
                N_("Very dissatisfied"),
                N_("Dissatisfied"),
                N_("Somewhat dissatisfied"),
                N_("Neither satisfied nor dissatisfied"),
                N_("Somewhat satisfied"),
                N_("Satisfied"),
                N_("Very satisfied"),
            ),
        },
    ),
    "Likelihood": Family(
        bipolar=True,
        labels={
            4: (N_("Very unlikely"), N_("Unlikely"), N_("Likely"), N_("Very likely")),
            5: (
                N_("Very unlikely"),
                N_("Unlikely"),
                N_("Neither likely nor unlikely"),
                N_("Likely"),
                N_("Very likely"),
            ),
            7: (
                N_("Very unlikely"),
                N_("Unlikely"),
                N_("Somewhat unlikely"),
                N_("Neither likely nor unlikely"),
                N_("Somewhat likely"),
                N_("Likely"),
                N_("Very likely"),
            ),
        },
    ),
    "Frequency": Family(
        bipolar=False,
        labels={
            4: (N_("Never"), N_("Sometimes"), N_("Often"), N_("Always")),
            5: (N_("Never"), N_("Rarely"), N_("Sometimes"), N_("Often"), N_("Always")),
            7: (
                N_("Never"),
                N_("Very rarely"),
                N_("Rarely"),
                N_("Sometimes"),
                N_("Often"),
                N_("Very often"),
                N_("Always"),
            ),
        },
    ),
    "Importance": Family(
        bipolar=False,
        labels={
            4: (
                N_("Not at all important"),
                N_("Slightly important"),
                N_("Very important"),
                N_("Extremely important"),
            ),
            5: (
                N_("Not at all important"),
                N_("Slightly important"),
                N_("Moderately important"),
                N_("Very important"),
                N_("Extremely important"),
            ),
            7: (
                N_("Not at all important"),
                N_("Very slightly important"),
                N_("Slightly important"),
                N_("Moderately important"),
                N_("Quite important"),
                N_("Very important"),
                N_("Extremely important"),
            ),
        },
    ),
    "Quality": Family(
        bipolar=False,
        labels={
            4: (N_("Poor"), N_("Fair"), N_("Good"), N_("Excellent")),
            5: (N_("Poor"), N_("Fair"), N_("Good"), N_("Very good"), N_("Excellent")),
            7: (
                N_("Very poor"),
                N_("Poor"),
                N_("Fair"),
                N_("Good"),
                N_("Very good"),
                N_("Excellent"),
                N_("Outstanding"),
            ),
        },
    ),
}


@dataclass(frozen=True)
class Option:
    """One choice as a respondent sees it: its stored code, its text, and whether it is an opt-out."""

    code: int
    label: str
    opt_out: bool


@dataclass(frozen=True)
class Scale:
    """A validated declaration. Build one with ``parse_scale``."""

    family: str
    points: int
    order: str = "ascending"
    opt_outs: tuple[str, ...] = ()

    @property
    def bipolar(self) -> bool:
        return FAMILIES[self.family].bipolar

    @property
    def point_codes(self) -> tuple[int, ...]:
        return tuple(range(1, self.points + 1))

    @property
    def opt_out_codes(self) -> tuple[int, ...]:
        return tuple(OPT_OUTS[name][0] for name in self.opt_outs)

    @property
    def codes(self) -> tuple[int, ...]:
        """Every code the item accepts: the points, then the opt-outs."""
        return self.point_codes + self.opt_out_codes

    @property
    def midpoint(self) -> int | None:
        if self.bipolar and self.points % 2 == 1:
            return (self.points + 1) // 2
        return None

    @property
    def negative_codes(self) -> tuple[int, ...]:
        """The disagree side of a bipolar scale (below the midpoint); empty for a unipolar one."""
        if not self.bipolar:
            return ()
        return tuple(range(1, self.points // 2 + 1))

    @property
    def positive_codes(self) -> tuple[int, ...]:
        """The agree side of a bipolar scale (above the midpoint); empty for a unipolar one."""
        if not self.bipolar:
            return ()
        return tuple(range(self.points - self.points // 2 + 1, self.points + 1))

    def msgid(self, code: int) -> str:
        """The catalog msgid for one code of this scale."""
        if code in self.point_codes:
            return FAMILIES[self.family].labels[self.points][code - 1]
        for name in self.opt_outs:
            reserved, msgid = OPT_OUTS[name]
            if reserved == code:
                return msgid
        raise ScaleError(f"code {code} is not part of this {self.family} scale")

    def catalog_label(self, code: int, locale: str) -> str:
        return gettext(locale, self.msgid(code))

    def display_order(self) -> list[tuple[int, bool]]:
        """``(code, is_opt_out)`` in the order a respondent sees them: the points as declared, then the opt-outs."""
        points = list(self.point_codes)
        if self.order == "descending":
            points.reverse()
        return [(code, False) for code in points] + [(code, True) for code in self.opt_out_codes]

    def options(self, locale: str, authored: Mapping[int, str] | None = None) -> list[Option]:
        """The choices in display order, labelled from ``authored`` or the catalog in ``locale``."""
        authored = authored or {}
        return [
            Option(code, authored.get(code) or self.catalog_label(code, locale), opt_out)
            for code, opt_out in self.display_order()
        ]

    def as_dict(self) -> dict:
        """The declaration as QML spells it, every key present."""
        return {
            "family": self.family,
            "points": self.points,
            "order": self.order,
            "optOuts": list(self.opt_outs),
        }


def parse_scale(raw: Mapping) -> Scale:
    """Validate one ``scale`` mapping and return it; raise ``ScaleError`` naming what is allowed."""
    if not isinstance(raw, Mapping):
        raise ScaleError("scale must be a mapping with family and points")
    family = raw.get("family")
    if family is None:
        raise ScaleError("scale needs a family")
    if family not in FAMILIES:
        raise ScaleError(f"unknown scale family {family!r}; use one of {', '.join(FAMILIES)}")
    points = raw.get("points")
    if isinstance(points, bool) or points not in POINT_COUNTS:
        raise ScaleError(f"a {family} scale has 4, 5 or 7 points, not {points!r}")
    order = raw.get("order", "ascending")
    if order not in ORDERS:
        raise ScaleError(f"scale order is ascending or descending, not {order!r}")
    opt_outs = tuple(raw.get("optOuts") or ())
    for name in opt_outs:
        if name not in OPT_OUTS:
            raise ScaleError(f"unknown opt-out {name!r}; use any of {', '.join(OPT_OUTS)}")
    if len(set(opt_outs)) != len(opt_outs):
        raise ScaleError("an opt-out is listed twice")
    # Display order of opt-outs is fixed by the catalog, whatever order the author listed them in.
    ordered = tuple(name for name in OPT_OUTS if name in opt_outs)
    return Scale(family=family, points=points, order=order, opt_outs=ordered)


def family_msgids(family: str, points: int) -> tuple[str, ...]:
    """The label msgids of one family at one point count, codes 1..N in order."""
    return FAMILIES[family].labels[points]
