"""Tests for the plotter.

Driven entirely by a hand-written results file — no generator, no validator —
which is exactly the property the plotter must have (figures regenerate from the
results file alone).
"""

from __future__ import annotations

import json

import pytest

pytest.importorskip("matplotlib")

from benchmark.plot import plot_all, plot_axis  # noqa: E402


def _ok_row(axis, value, total, z3, mem):
    return {
        "axis": axis,
        "axis_value": value,
        "status": "ok",
        "total_s_median": total,
        "total_s_min": total * 0.9,
        "total_s_max": total * 1.1,
        "z3_s_median": z3,
        "z3_s_min": z3 * 0.9,
        "z3_s_max": z3 * 1.1,
        "rss_mib_median": mem,
        "rss_mib_min": mem - 1,
        "rss_mib_max": mem + 1,
        "achieved_depth": 1,
    }


def _fixture_results():
    return {
        "provenance": {"mode": "smoke"},
        "rows": [
            _ok_row("items", 10, 0.01, 0.005, 60.0),
            _ok_row("items", 100, 0.05, 0.03, 65.0),
            _ok_row("items", 1000, 0.5, 0.4, 90.0),
            _ok_row("depth", 1, 0.01, 0.005, 60.0),
            _ok_row("depth", 8, 0.2, 0.18, 70.0),
        ],
    }


def test_plot_all_one_png_per_axis(tmp_path):
    results = tmp_path / "results.json"
    results.write_text(json.dumps(_fixture_results()), encoding="utf-8")
    figures = tmp_path / "figures"
    paths = plot_all(results, figures)
    assert {p.name for p in paths} == {"items.png", "depth.png"}
    for p in paths:
        assert p.exists() and p.stat().st_size > 0


def test_plot_axis_handles_timeout_points(tmp_path):
    rows = [
        _ok_row("depth", 1, 0.01, 0.005, 60.0),
        _ok_row("depth", 8, 0.2, 0.18, 70.0),
        {"axis": "depth", "axis_value": 25, "status": "timeout", "timeout_s": 120.0},
    ]
    out = plot_axis("depth", rows, tmp_path)
    assert out.exists() and out.stat().st_size > 0


def test_plot_axis_all_timeouts_still_renders(tmp_path):
    rows = [
        {"axis": "items", "axis_value": 500, "status": "timeout", "timeout_s": 1.0},
        {"axis": "items", "axis_value": 1000, "status": "timeout", "timeout_s": 1.0},
    ]
    out = plot_axis("items", rows, tmp_path)
    assert out.exists() and out.stat().st_size > 0
