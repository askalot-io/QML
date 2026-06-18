"""Tests for the instrumented, subprocess-isolated runner."""

from __future__ import annotations

from pathlib import Path

from benchmark.generator import GenConfig, write_qml
from benchmark.runner import measure_once, run_repeated, run_validation


def _make_qml(tmp_path: Path, **kwargs) -> tuple[Path, object]:
    path = tmp_path / "bench.qml"
    stats = write_qml(GenConfig(**kwargs), path)
    return path, stats


def test_measure_once_splits_parse_construction_and_z3(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=15, n_preconditions=6, n_postconditions=5, depth=4)
    record = measure_once(path)
    # Three distinct phases, and total is exactly their sum (summed from deltas).
    assert record["parse_s"] > 0
    assert record["construction_s"] > 0
    assert record["z3_s"] > 0
    assert record["total_s"] == record["parse_s"] + record["construction_s"] + record["z3_s"]


def test_measure_once_reports_process_rss_not_tracemalloc(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=10, depth=2)
    record = measure_once(path)
    # A Python+Z3 process resident set is tens of MiB; tracemalloc of just the
    # validation would be a small fraction of that. >20 MiB confirms we measured
    # whole-process RSS, which includes Z3's native allocations.
    assert record["rss_mib"] > 20


def test_measure_once_records_achieved_depth(tmp_path):
    path, stats = _make_qml(tmp_path, n_items=6, depth=6)
    record = measure_once(path)
    assert record["achieved_depth"] == stats.achieved_depth == 6
    assert record["item_count"] == 6


def test_run_validation_ok(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=12, n_preconditions=4, depth=3)
    result = run_validation(path, timeout_s=120.0)
    assert result["status"] == "ok"
    assert result["total_s"] > 0


def test_run_validation_timeout_records_noncompletion(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=30, n_preconditions=10, depth=5)
    # A 1ms wall-clock budget cannot even start the child process — the parent
    # records a timeout instead of raising or aborting.
    result = run_validation(path, timeout_s=0.001)
    assert result["status"] == "timeout"


def test_run_repeated_aggregates(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=10, n_postconditions=4, depth=2)
    result = run_repeated(path, reps=3, warmup=1, timeout_s=120.0)
    assert result["status"] == "ok"
    assert result["reps"] == 3
    for field in ("parse_s", "construction_s", "z3_s", "total_s", "rss_mib"):
        assert f"{field}_median" in result
        assert result[f"{field}_min"] <= result[f"{field}_median"] <= result[f"{field}_max"]


def test_run_repeated_propagates_timeout(tmp_path):
    path, _ = _make_qml(tmp_path, n_items=20, depth=4)
    result = run_repeated(path, reps=3, warmup=0, timeout_s=0.001)
    assert result["status"] == "timeout"
