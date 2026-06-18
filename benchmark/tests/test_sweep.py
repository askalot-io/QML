"""Tests for the sweep driver and results emission."""

from __future__ import annotations

import json

from benchmark.config import SweepSpec, sweeps
from benchmark.sweep import build_provenance, run_sweep, write_results


def _tiny_items_spec() -> SweepSpec:
    return SweepSpec(
        axis="items",
        values=(5, 8),
        baseline={"n_preconditions": 0, "n_postconditions": 0, "depth": 1},
    )


def test_run_sweep_one_row_per_value(tmp_path):
    rows = run_sweep(
        _tiny_items_spec(),
        results_dir=tmp_path / "r",
        reps=1,
        warmup=0,
        timeout_s=120.0,
        seed=1,
        log=lambda *_: None,
    )
    assert len(rows) == 2
    for row, value in zip(rows, (5, 8)):
        assert row["axis"] == "items"
        assert row["axis_value"] == value
        assert row["status"] == "ok"
        assert row["total_s_median"] > 0
        assert row["item_count"] == value


def test_provenance_has_required_fields():
    prov = build_provenance(mode="smoke", reps=3, warmup=1, timeout_s=60.0, seed=42)
    for key in (
        "python_version",
        "z3_solver_version",
        "askalot_qml_version",
        "machine",
        "cpu_count",
        "reps",
        "seed",
        "rss_unit",
    ):
        assert key in prov
    assert prov["seed"] == 42
    assert prov["z3_solver_version"] != "unknown"


def test_results_roundtrip(tmp_path):
    rows = run_sweep(
        _tiny_items_spec(),
        results_dir=tmp_path / "r",
        reps=1,
        warmup=0,
        timeout_s=120.0,
        seed=1,
        log=lambda *_: None,
    )
    prov = build_provenance(mode="smoke", reps=1, warmup=0, timeout_s=120.0, seed=1)
    out = tmp_path / "results.json"
    write_results(prov, rows, out)
    loaded = json.loads(out.read_text())
    assert loaded["provenance"]["mode"] == "smoke"
    assert len(loaded["rows"]) == 2
    assert loaded["rows"][0]["axis"] == "items"


def test_noncompletion_rows_are_written_not_dropped(tmp_path):
    # A 1ms timeout cannot complete any run; every point must still produce a row.
    rows = run_sweep(
        _tiny_items_spec(),
        results_dir=tmp_path / "r",
        reps=2,
        warmup=0,
        timeout_s=0.001,
        seed=1,
        log=lambda *_: None,
    )
    assert len(rows) == 2
    assert all(r["status"] == "timeout" for r in rows)


def test_run_sweep_reuses_existing_qml_but_generates_missing(tmp_path):
    from benchmark.generator import GenConfig, write_qml

    qdir = tmp_path / "q"
    # Pre-seed one of the sweep's files with a valid but distinct questionnaire.
    write_qml(GenConfig(n_items=3, depth=1), qdir / "items_5.qml")
    preexisting = (qdir / "items_5.qml").read_text()

    run_sweep(
        _tiny_items_spec(),
        results_dir=qdir,
        reps=1,
        warmup=0,
        timeout_s=120.0,
        seed=1,
        regenerate=False,
        log=lambda *_: None,
    )
    # items_5.qml existed -> reused (untouched); items_8.qml was missing -> generated.
    assert (qdir / "items_5.qml").read_text() == preexisting
    assert (qdir / "items_8.qml").exists()

    # Forcing regeneration overwrites the reused file.
    run_sweep(
        _tiny_items_spec(),
        results_dir=qdir,
        reps=1,
        warmup=0,
        timeout_s=120.0,
        seed=1,
        regenerate=True,
        log=lambda *_: None,
    )
    assert (qdir / "items_5.qml").read_text() != preexisting


def test_smoke_sweeps_satisfy_generator_guards():
    # Every smoke point must build a valid GenConfig (no guard violation).
    for spec in sweeps("smoke").values():
        for value in spec.values:
            spec.config_for(value, seed=0)


def test_paper_sweeps_satisfy_generator_guards():
    for spec in sweeps("paper").values():
        for value in spec.values:
            spec.config_for(value, seed=0)
