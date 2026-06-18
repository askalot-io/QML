"""Sweep driver: generate -> validate -> record, one axis at a time.

Drives the four single-axis sweeps, writing each generated questionnaire to
``results/<axis>_<value>.qml`` and each measurement to a single JSON results
file with a provenance header. The plotter reads only that file, so figures
regenerate without re-running validation.

CLI (run from the repo root via the benchmark project)::

    uv run --project benchmark python -m benchmark.sweep            # paper-grade, all axes
    uv run --project benchmark python -m benchmark.sweep --smoke     # fast smoke
    uv run --project benchmark python -m benchmark.sweep --axis depth --reps 3
"""

from __future__ import annotations

import argparse
import json
import os
import platform
import sys
from datetime import datetime, timezone
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path
from typing import Any

from benchmark.config import AXES, DEFAULT_SEED, SweepSpec, sweeps
from benchmark.generator import write_qml
from benchmark.runner import REPO_ROOT, run_repeated

DEFAULT_RESULTS = REPO_ROOT / "benchmark" / "results"
DEFAULT_OUT = DEFAULT_RESULTS / "results.json"


def _pkg_version(name: str) -> str:
    try:
        return version(name)
    except PackageNotFoundError:
        return "unknown"


def build_provenance(
    *, mode: str, reps: int, warmup: int, timeout_s: float, seed: int
) -> dict[str, Any]:
    """Record the environment a sweep ran in, so the paper's results are reproducible."""
    return {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "mode": mode,
        "python_version": platform.python_version(),
        "z3_solver_version": _pkg_version("z3-solver"),
        "askalot_qml_version": _pkg_version("askalot_qml"),
        "platform": platform.platform(),
        "machine": platform.machine(),
        "processor": platform.processor(),
        "cpu_count": os.cpu_count(),
        "rss_unit": "MiB",
        "time_unit": "s",
        "reps": reps,
        "warmup": warmup,
        "timeout_s": timeout_s,
        "seed": seed,
    }


def run_sweep(
    spec: SweepSpec,
    *,
    results_dir: Path,
    reps: int,
    warmup: int,
    timeout_s: float,
    seed: int,
    regenerate: bool = False,
    log=print,
) -> list[dict[str, Any]]:
    """Run one axis sweep and return one row per swept value (completions and not).

    By default an existing ``<axis>_<value>.qml`` is reused, not rewritten. Pass
    ``regenerate=True`` to force fresh generation (do this after changing the
    seed or the sweep ranges, since reuse assumes the on-disk file matches the
    current config).
    """
    results_dir.mkdir(parents=True, exist_ok=True)
    rows: list[dict[str, Any]] = []
    for value in spec.values:
        cfg = spec.config_for(value, seed)
        qml_path = results_dir / f"{spec.axis}_{value}.qml"
        reused = qml_path.exists() and not regenerate
        gstats = write_qml(cfg, qml_path, overwrite=regenerate)
        if reused:
            log(f"  {spec.axis}={value}: reusing existing {qml_path.name}")

        result = run_repeated(qml_path, reps=reps, warmup=warmup, timeout_s=timeout_s)

        row: dict[str, Any] = {
            "axis": spec.axis,
            "axis_value": value,
            "n_items": cfg.n_items,
            "n_preconditions": cfg.n_preconditions,
            "n_postconditions": cfg.n_postconditions,
            "depth": cfg.depth,
            "seed": cfg.seed,
            # Analytic (generator-side) expectations, for cross-checking.
            "expected_depth": gstats.achieved_depth,
            "expected_preconditions": gstats.achieved_preconditions,
            "expected_postconditions": gstats.achieved_postconditions,
        }
        row.update(result)  # status + measured/structural fields (or timeout/error detail)
        rows.append(row)
        _log_row(log, row)
    return rows


def _log_row(log, row: dict[str, Any]) -> None:
    if row.get("status") == "ok":
        log(
            f"  {row['axis']}={row['axis_value']}: "
            f"total={row['total_s_median']:.4f}s "
            f"z3={row['z3_s_median']:.4f}s "
            f"rss={row['rss_mib_median']:.1f}MiB "
            f"(depth={row.get('achieved_depth')})"
        )
    else:
        log(f"  {row['axis']}={row['axis_value']}: {row.get('status')} "
            f"({row.get('detail') or row.get('timeout_s')})")


def write_results(provenance: dict[str, Any], rows: list[dict[str, Any]], out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(
        json.dumps({"provenance": provenance, "rows": rows}, indent=2),
        encoding="utf-8",
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Run QML validator scaling sweeps.")
    parser.add_argument("--smoke", action="store_true", help="Use small smoke ranges.")
    parser.add_argument(
        "--axis",
        choices=(*AXES, "all"),
        default="all",
        help="Which axis to sweep (default: all).",
    )
    parser.add_argument("--reps", type=int, default=5, help="Measured repetitions per point.")
    parser.add_argument("--warmup", type=int, default=1, help="Discarded warm-up runs per point.")
    parser.add_argument("--timeout", type=float, default=120.0, help="Per-run timeout (seconds).")
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED, help="Generator seed.")
    parser.add_argument(
        "--regenerate",
        action="store_true",
        help="Overwrite existing .qml artifacts (default: reuse them). "
        "Use after changing --seed or the sweep ranges.",
    )
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT, help="Results JSON path.")
    parser.add_argument(
        "--results-dir",
        type=Path,
        default=DEFAULT_RESULTS,
        help="Directory for generated .qml artifacts.",
    )
    args = parser.parse_args(argv)

    mode = "smoke" if args.smoke else "paper"
    spec_map = sweeps(mode)
    selected = AXES if args.axis == "all" else (args.axis,)

    provenance = build_provenance(
        mode=mode, reps=args.reps, warmup=args.warmup, timeout_s=args.timeout, seed=args.seed
    )

    all_rows: list[dict[str, Any]] = []
    for axis in selected:
        print(f"Sweeping {axis} ({mode})...")
        all_rows.extend(
            run_sweep(
                spec_map[axis],
                results_dir=args.results_dir,
                reps=args.reps,
                warmup=args.warmup,
                timeout_s=args.timeout,
                seed=args.seed,
                regenerate=args.regenerate,
            )
        )

    write_results(provenance, all_rows, args.out)
    print(f"Wrote {len(all_rows)} rows to {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
