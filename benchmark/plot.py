"""Render scaling figures from a sweep's results file.

One PNG per axis: validation time (total, parse, and isolated Z3 solve, each
with a min/max band across repetitions) on top, peak memory below, sharing the
swept-axis x. Non-completion (timeout) points are marked distinctly.

The plotter reads ONLY the results JSON — it imports neither the generator nor
the validator — so figures regenerate (or restyle) without re-running anything.

CLI (from the repo root via the benchmark project)::

    uv run --project benchmark python -m benchmark.plot
    uv run --project benchmark python -m benchmark.plot --results path/to/results.json
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")  # headless: write PNGs, never open a display
import matplotlib.pyplot as plt  # noqa: E402

from benchmark.runner import REPO_ROOT  # noqa: E402

DEFAULT_RESULTS = REPO_ROOT / "benchmark" / "results" / "results.json"
DEFAULT_FIGURES = REPO_ROOT / "benchmark" / "figures"

_AXIS_LABEL = {
    "items": "number of items",
    "preconditions": "number of preconditions",
    "postconditions": "number of postconditions",
    "depth": "dependency depth",
}


def load_results(path: str | Path) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    return data.get("provenance", {}), data.get("rows", [])


def plot_axis(axis: str, rows: list[dict[str, Any]], figures_dir: Path) -> Path:
    """Render one axis's figure to ``figures_dir/<axis>.png`` and return the path."""
    axis_rows = sorted(
        (r for r in rows if r.get("axis") == axis), key=lambda r: r["axis_value"]
    )
    completed = [r for r in axis_rows if r.get("status") == "ok"]
    incomplete = [r for r in axis_rows if r.get("status") != "ok"]

    fig, (ax_time, ax_mem) = plt.subplots(2, 1, figsize=(7, 7), sharex=True)

    if completed:
        xs = [r["axis_value"] for r in completed]

        def band(field: str):
            med = [r[f"{field}_median"] for r in completed]
            lo = [r[f"{field}_min"] for r in completed]
            hi = [r[f"{field}_max"] for r in completed]
            return med, lo, hi

        total_med, total_lo, total_hi = band("total_s")
        z3_med, z3_lo, z3_hi = band("z3_s")
        mem_med, mem_lo, mem_hi = band("rss_mib")

        ax_time.plot(xs, total_med, marker="o", label="total")
        ax_time.fill_between(xs, total_lo, total_hi, alpha=0.2)
        # Parse phase, present in results produced after parse timing was added;
        # guarded so older results files (total + Z3 only) still plot.
        if "parse_s_median" in completed[0]:
            parse_med, parse_lo, parse_hi = band("parse_s")
            ax_time.plot(xs, parse_med, marker="d", label="parse")
            ax_time.fill_between(xs, parse_lo, parse_hi, alpha=0.2)
        ax_time.plot(xs, z3_med, marker="s", label="Z3 solve")
        ax_time.fill_between(xs, z3_lo, z3_hi, alpha=0.2)

        ax_mem.plot(xs, mem_med, marker="^", color="C2", label="peak RSS")
        ax_mem.fill_between(xs, mem_lo, mem_hi, alpha=0.2, color="C2")

    # Mark non-completion points distinctly so an empty stretch reads as
    # "validator timed out here", not "no data".
    for r in incomplete:
        for ax in (ax_time, ax_mem):
            ax.axvline(r["axis_value"], ls=":", color="red", alpha=0.6)
        ax_time.annotate(
            "timeout",
            xy=(r["axis_value"], 0),
            xytext=(0, 4),
            textcoords="offset points",
            rotation=90,
            color="red",
            fontsize=8,
            va="bottom",
            ha="right",
        )

    ax_time.set_title(f"QML validation cost vs {_AXIS_LABEL.get(axis, axis)}")
    ax_time.set_ylabel("time (s)")
    if completed:
        ax_time.legend()
    ax_time.grid(True, alpha=0.3)
    ax_mem.set_ylabel("peak memory (MiB)")
    ax_mem.set_xlabel(_AXIS_LABEL.get(axis, axis))
    ax_mem.grid(True, alpha=0.3)

    figures_dir.mkdir(parents=True, exist_ok=True)
    out = figures_dir / f"{axis}.png"
    fig.tight_layout()
    fig.savefig(out, dpi=120)
    plt.close(fig)
    return out


def plot_all(results_path: str | Path, figures_dir: str | Path) -> list[Path]:
    """Render one figure per axis present in the results file."""
    _provenance, rows = load_results(results_path)
    figures_dir = Path(figures_dir)
    axes_present: list[str] = []
    for r in rows:
        if r.get("axis") not in axes_present:
            axes_present.append(r["axis"])
    return [plot_axis(axis, rows, figures_dir) for axis in axes_present]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Render QML validator scaling figures.")
    parser.add_argument("--results", type=Path, default=DEFAULT_RESULTS, help="Results JSON path.")
    parser.add_argument(
        "--figures-dir", type=Path, default=DEFAULT_FIGURES, help="Output directory for PNGs."
    )
    args = parser.parse_args(argv)

    if not args.results.exists():
        print(f"Results file not found: {args.results}. Run a sweep first.", file=sys.stderr)
        return 1

    paths = plot_all(args.results, args.figures_dir)
    for p in paths:
        print(f"Wrote {p}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
