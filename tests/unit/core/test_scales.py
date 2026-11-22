"""
The rating-scale catalog: families, point counts, reserved opt-out codes and expansion.

Tests cover:
- A five-point Agreement scale expands to codes 1 to 5 with its midpoint at 3.
- A four-point bipolar scale has no midpoint; a unipolar scale never has one.
- Descending order shows the same codes in reverse, opt-outs always last.
- Each opt-out expands to its reserved code and catalog label.
- No English label is shared by two families (the catalog has no message
  context); ``make i18n-check`` holds that every label is translated.
- Agree-side and disagree-side codes of a bipolar scale; none for a unipolar one.
- An unknown family, point count, order or opt-out is refused with a message
  naming what is allowed.

These unit tests drive the module's public functions directly, because every
other consumer (loader, validator, measures, exports) reads a family's codes only
through them; a wrong code here would be wrong everywhere.
"""

from __future__ import annotations

import pytest
from askalot_common.i18n import gettext
from askalot_qml.core import scales
from askalot_qml.core.scales import ScaleError, parse_scale


class TestExpansion:
    def test_five_point_agreement_has_codes_one_to_five_and_midpoint_three(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 5})

        assert scale.point_codes == (1, 2, 3, 4, 5)
        assert scale.midpoint == 3
        assert [o.label for o in scale.options("en")] == [
            "Strongly disagree",
            "Disagree",
            "Neither agree nor disagree",
            "Agree",
            "Strongly agree",
        ]

    def test_four_point_bipolar_scale_has_no_midpoint(self) -> None:
        assert parse_scale({"family": "Satisfaction", "points": 4}).midpoint is None

    @pytest.mark.parametrize("points", [4, 5, 7])
    def test_a_unipolar_scale_never_has_a_midpoint(self, points: int) -> None:
        assert parse_scale({"family": "Frequency", "points": points}).midpoint is None

    def test_seven_point_bipolar_midpoint_is_four(self) -> None:
        assert parse_scale({"family": "Likelihood", "points": 7}).midpoint == 4

    def test_descending_order_reverses_display_but_not_codes(self) -> None:
        scale = parse_scale(
            {"family": "Agreement", "points": 5, "order": "descending", "optOuts": ["dontKnow"]}
        )

        assert [o.code for o in scale.options("en")] == [5, 4, 3, 2, 1, 97]
        assert scale.options("en")[0].label == "Strongly agree"
        assert scale.point_codes == (1, 2, 3, 4, 5)

    def test_each_opt_out_expands_to_its_reserved_code_and_label(self) -> None:
        scale = parse_scale(
            {
                "family": "Quality",
                "points": 5,
                "optOuts": ["preferNotToSay", "dontKnow", "notApplicable"],
            }
        )

        tail = [(o.code, o.label, o.opt_out) for o in scale.options("en")][5:]
        assert tail == [
            (97, "Don't know", True),
            (98, "Does not apply to me", True),
            (99, "Prefer not to say", True),
        ]
        assert scale.opt_out_codes == (97, 98, 99)
        assert scale.codes == (1, 2, 3, 4, 5, 97, 98, 99)
        assert not any(o.opt_out for o in scale.options("en")[:5])

    def test_options_take_authored_labels_over_the_catalog(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 4})

        labels = [o.label for o in scale.options("en", authored={1: "Not at all", 4: "Fully"})]

        assert labels == ["Not at all", "Disagree", "Agree", "Fully"]

    def test_hungarian_options_carry_hungarian_text(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 5})

        assert scale.options("hu")[0].label == gettext("hu", "Strongly disagree")
        assert scale.options("hu")[0].label != "Strongly disagree"


class TestSides:
    def test_bipolar_sides_exclude_the_midpoint(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 5})

        assert scale.negative_codes == (1, 2)
        assert scale.positive_codes == (4, 5)

    def test_even_bipolar_sides_split_in_half(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 4})

        assert scale.negative_codes == (1, 2)
        assert scale.positive_codes == (3, 4)

    def test_seven_point_sides(self) -> None:
        scale = parse_scale({"family": "Agreement", "points": 7})

        assert scale.negative_codes == (1, 2, 3)
        assert scale.positive_codes == (5, 6, 7)

    def test_a_unipolar_scale_has_no_sides(self) -> None:
        scale = parse_scale({"family": "Importance", "points": 5})

        assert scale.negative_codes == ()
        assert scale.positive_codes == ()


class TestCatalog:
    def test_no_english_label_is_shared_by_two_families(self) -> None:
        owners: dict[str, set[str]] = {}
        for family in scales.FAMILIES:
            for points in scales.POINT_COUNTS:
                for msgid in scales.family_msgids(family, points):
                    owners.setdefault(msgid, set()).add(family)

        assert {m: f for m, f in owners.items() if len(f) > 1} == {}

    def test_each_family_has_its_polarity(self) -> None:
        bipolar = {f for f, fam in scales.FAMILIES.items() if fam.bipolar}

        assert bipolar == {"Agreement", "Satisfaction", "Likelihood"}
        assert set(scales.FAMILIES) - bipolar == {"Frequency", "Importance", "Quality"}

    @pytest.mark.parametrize("family", sorted(scales.FAMILIES))
    @pytest.mark.parametrize("points", scales.POINT_COUNTS)
    def test_every_family_and_count_has_one_label_per_point(self, family: str, points: int) -> None:
        msgids = scales.family_msgids(family, points)

        assert len(msgids) == points
        assert len(set(msgids)) == points


class TestRefusals:
    @pytest.mark.parametrize(
        ("raw", "needle"),
        [
            ({"family": "Mood", "points": 5}, "Agreement"),
            ({"family": "Agreement", "points": 6}, "4, 5 or 7"),
            ({"family": "Agreement", "points": 5, "order": "sideways"}, "ascending"),
            ({"family": "Agreement", "points": 5, "optOuts": ["maybe"]}, "dontKnow"),
            ({"family": "Agreement", "points": 5, "optOuts": ["dontKnow", "dontKnow"]}, "twice"),
            ({"points": 5}, "family"),
        ],
    )
    def test_a_malformed_declaration_is_refused(self, raw: dict, needle: str) -> None:
        with pytest.raises(ScaleError, match=needle):
            parse_scale(raw)
