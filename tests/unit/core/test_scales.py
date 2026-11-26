"""
The structure of a declared rating scale: range, midpoint, sides, out-of-scale codes, display order.

Tests cover:
- A bipolar five-point scale from 1 has codes 1 to 5, midpoint 3 and two codes
  on each side; a bipolar seven-point scale from 0 has its midpoint at 3.
- An even bipolar scale splits in half with no midpoint; a two-point one has
  one code on each side.
- A unipolar scale of any length has no midpoint and no sides.
- A scale starting at 0 runs 0 to points - 1.
- Out-of-scale codes are the given codes above the range, ascending; a code
  below the first point is not one.
- Descending display reverses the points and keeps out-of-scale codes last.
- A declaration with a wrong polarity, point count, start or order, or with
  any other key, is refused with a message naming what is allowed; the point
  count is bounded above, and ``start`` and ``points`` are whole numbers, never
  a float equal to one.
- A refusal names the first few codes and counts the rest.
- ``as_dict`` spells every key and round-trips through ``parse_scale``.

These unit tests drive the module's public functions directly, because every
other consumer (loader, validator, measures, exports) derives a scale's range
and sides only through them; a wrong code here would be wrong everywhere.
"""

from __future__ import annotations

import pytest
from askalot_qml.core.scales import (
    MAX_POINTS,
    NAMED_CODES,
    Scale,
    ScaleError,
    name_codes,
    parse_scale,
)


class TestStructure:
    def test_bipolar_five_from_one_has_midpoint_three_and_two_codes_a_side(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 5})
        assert scale.start == 1
        assert scale.point_codes == (1, 2, 3, 4, 5)
        assert scale.top == 5
        assert scale.midpoint == 3
        assert scale.negative_codes == (1, 2)
        assert scale.positive_codes == (4, 5)

    def test_bipolar_six_splits_in_half_with_no_midpoint(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 6})
        assert scale.midpoint is None
        assert scale.negative_codes == (1, 2, 3)
        assert scale.positive_codes == (4, 5, 6)

    def test_bipolar_seven_from_zero_has_midpoint_three(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 7, "start": 0})
        assert scale.point_codes == (0, 1, 2, 3, 4, 5, 6)
        assert scale.midpoint == 3
        assert scale.negative_codes == (0, 1, 2)
        assert scale.positive_codes == (4, 5, 6)

    def test_bipolar_two_has_one_code_on_each_side(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 2})
        assert scale.midpoint is None
        assert scale.negative_codes == (1,)
        assert scale.positive_codes == (2,)

    @pytest.mark.parametrize("points", [2, 3, 5, 10, 11])
    @pytest.mark.parametrize("start", [0, 1])
    def test_unipolar_has_no_midpoint_and_no_sides(self, points: int, start: int) -> None:
        scale = parse_scale({"polarity": "unipolar", "points": points, "start": start})
        assert scale.midpoint is None
        assert scale.negative_codes == ()
        assert scale.positive_codes == ()

    def test_unipolar_eleven_from_zero_runs_zero_to_ten(self) -> None:
        scale = parse_scale({"polarity": "unipolar", "points": 11, "start": 0})
        assert scale.point_codes == tuple(range(11))
        assert scale.top == 10


class TestOutOfScale:
    def test_codes_above_the_range_are_out_of_scale_ascending(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 5})
        assert scale.out_of_scale([99, 1, 5, 8]) == (8, 99)

    def test_a_code_below_the_first_point_is_not_out_of_scale(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 5})
        assert scale.out_of_scale([0, -1, 3]) == ()

    def test_the_first_code_above_a_zero_based_range_is_out_of_scale(self) -> None:
        scale = parse_scale({"polarity": "unipolar", "points": 11, "start": 0})
        assert scale.out_of_scale(range(13)) == (11, 12)


class TestDisplayOrder:
    def test_ascending_shows_points_low_to_high_then_out_of_scale(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 5})
        assert scale.display_order([9, 1, 2, 3, 4, 5, 8]) == [
            (1, False),
            (2, False),
            (3, False),
            (4, False),
            (5, False),
            (8, True),
            (9, True),
        ]

    def test_descending_reverses_the_points_and_keeps_out_of_scale_last_ascending(self) -> None:
        scale = parse_scale({"polarity": "bipolar", "points": 5, "order": "descending"})
        assert [code for code, _ in scale.display_order([1, 2, 3, 4, 5, 8, 9])] == [
            5,
            4,
            3,
            2,
            1,
            8,
            9,
        ]
        # Display order never changes what a code is.
        assert scale.point_codes == (1, 2, 3, 4, 5)
        assert scale.positive_codes == (4, 5)

    def test_every_point_is_shown_whatever_codes_are_given(self) -> None:
        scale = parse_scale({"polarity": "unipolar", "points": 3, "start": 0})
        assert scale.display_order([]) == [(0, False), (1, False), (2, False)]


class TestRefusals:
    @pytest.mark.parametrize(
        ("raw", "needle"),
        [
            ({"polarity": "bipolar", "points": 1}, "from 2 to 101"),
            ({"polarity": "bipolar", "points": MAX_POINTS + 1}, "from 2 to 101"),
            ({"polarity": "unipolar", "points": 10**9}, "from 2 to 101"),
            ({"polarity": "bipolar", "points": 5.0}, "whole number"),
            ({"polarity": "bipolar", "points": 2.5}, "whole number"),
            ({"polarity": "bipolar", "points": True}, "whole number"),
            ({"polarity": "bipolar", "points": "5"}, "whole number"),
            ({"polarity": "bipolar"}, "number of points"),
            ({"points": 5}, "needs a polarity"),
            ({"polarity": "neutral", "points": 5}, "bipolar or unipolar"),
            ({"polarity": "bipolar", "points": 5, "start": 2}, "0 or 1"),
            ({"polarity": "bipolar", "points": 5, "start": True}, "0 or 1"),
            ({"polarity": "bipolar", "points": 5, "start": 1.0}, "0 or 1"),
            ({"polarity": "bipolar", "points": 5, "start": 0.0}, "0 or 1"),
            ({"polarity": "bipolar", "points": 5, "order": "random"}, "ascending or descending"),
            ({"family": "Agreement", "points": 5}, "'family'"),
            ({"polarity": "bipolar", "points": 5, "optOuts": ["dontKnow"]}, "'optOuts'"),
            ({"polarity": "bipolar", "points": 5, "reversed": True}, "'reversed'"),
            ("bipolar", "mapping"),
        ],
    )
    def test_a_malformed_declaration_is_refused(self, raw, needle: str) -> None:
        with pytest.raises(ScaleError, match=needle):
            parse_scale(raw)

    def test_the_widest_scale_runs_zero_to_one_hundred(self) -> None:
        scale = parse_scale({"polarity": "unipolar", "points": MAX_POINTS, "start": 0})
        assert (scale.start, scale.top) == (0, 100)

    def test_a_refusal_names_the_first_codes_and_counts_the_rest(self) -> None:
        assert name_codes([4, 5]) == "4, 5"
        assert name_codes(range(NAMED_CODES)) == "0, 1, 2, 3, 4, 5, 6, 7"
        assert name_codes(range(3, 102)) == "3, 4, 5, 6, 7, 8, 9, 10 and 91 more"


class TestSpelling:
    def test_as_dict_carries_every_key(self) -> None:
        assert parse_scale({"polarity": "unipolar", "points": 4}).as_dict() == {
            "polarity": "unipolar",
            "points": 4,
            "start": 1,
            "order": "ascending",
        }

    @pytest.mark.parametrize(
        "scale",
        [
            Scale("bipolar", 5),
            Scale("unipolar", 11, start=0),
            Scale("bipolar", 7, start=0, order="descending"),
        ],
    )
    def test_as_dict_round_trips_through_parse_scale(self, scale: Scale) -> None:
        assert parse_scale(scale.as_dict()) == scale
