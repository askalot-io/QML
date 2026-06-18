"""End-to-end smoke test: generate -> sweep -> results -> plot.

Exercises the full CLI wiring on the fast smoke ranges for a single axis, so it
runs in a few seconds while proving the generate->validate->record->plot path is
connected.
"""

from __future__ import annotations

import json

import pytest

pytest.importorskip("matplotlib")

from benchmark import plot, sweep  # noqa: E402


def test_end_to_end_items_smoke(tmp_path):
    results = tmp_path / "results.json"
    figures = tmp_path / "figures"

    rc = sweep.main(
        [
            "--smoke",
            "--axis", "items",
            "--reps", "1",
            "--warmup", "0",
            "--out", str(results),
            "--results-dir", str(tmp_path / "qml"),
        ]
    )
    assert rc == 0
    assert results.exists()

    data = json.loads(results.read_text())
    assert data["provenance"]["mode"] == "smoke"
    assert len(data["rows"]) == 3  # smoke items sweep has 3 points
    assert all(r["status"] == "ok" for r in data["rows"])

    rc = plot.main(["--results", str(results), "--figures-dir", str(figures)])
    assert rc == 0
    assert (figures / "items.png").exists()
    assert (figures / "items.png").stat().st_size > 0
