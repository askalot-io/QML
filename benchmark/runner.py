"""Instrumented, subprocess-isolated single-validation runner.

Each measured validation runs in a *fresh subprocess* (``measure_once`` is the
child entry point, invoked via ``python -m benchmark.runner <qml>``). A fresh
process is required for a clean peak-RSS reading: Z3 allocates natively and does
not return memory to the OS until the process exits, so reusing a process would
accumulate. The subprocess also isolates the parent from any Z3 crash at scale.

Timing splits the validator into two phases, mirroring the integration-test
invocation (not ``ValidationProcessor.validate()``, which also builds the text
report and diagram IR):

- **construction** — ``QMLState`` + ``QMLEngine`` (``StaticBuilder`` constraint
  generation + ``QMLTopology`` dependency discovery).
- **z3** — ``ItemClassifier(...).classify_all_items()`` (the SMT solve).

``total = construction + z3``. YAML loading happens before the clock starts, so
"total" measures the validator, not file I/O.

Memory is peak process RSS via ``resource.getrusage`` — never ``tracemalloc``,
which is blind to Z3's native allocations. ``ru_maxrss`` is KiB on Linux and
bytes on macOS; both are normalized to MiB.
"""

from __future__ import annotations

import json
import resource
import statistics
import subprocess
import sys
from pathlib import Path
from time import perf_counter
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[1]

# Metrics aggregated as median + min + max across repetitions.
_TIMING_FIELDS = ("construction_s", "z3_s", "total_s", "rss_mib")
# Structural metrics, identical across repetitions of the same questionnaire.
_STRUCTURAL_FIELDS = (
    "achieved_depth",
    "item_count",
    "z3_constraints_total",
    "z3_variables",
)


def _rss_kib_to_mib(ru_maxrss: int) -> float:
    """Normalize ``ru_maxrss`` to MiB. Linux reports KiB; macOS reports bytes."""
    if sys.platform == "darwin":
        return ru_maxrss / (1024.0 * 1024.0)
    return ru_maxrss / 1024.0


def measure_once(qml_path: str | Path) -> dict[str, Any]:
    """Load, validate, and measure one questionnaire in the current process.

    Returns a flat record of timings (seconds), peak RSS (MiB), and structural
    counts. Intended to run inside a fresh subprocess (see ``_child_main``), but
    callable directly for in-process testing.
    """
    # Imported here, not at module top, so the parent process (which only
    # orchestrates subprocesses) need not import the validator or Z3.
    from askalot_qml.core.qml_engine import QMLEngine
    from askalot_qml.core.qml_loader import QMLLoader
    from askalot_qml.models.qml_state import QMLState
    from askalot_qml.z3.item_classifier import ItemClassifier

    # --- Untimed: parse YAML off disk (schema-less; schema is parse-time work). ---
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(qml_path))

    # --- Timed phase 1: construction (StaticBuilder + topology). ---
    t0 = perf_counter()
    state = QMLState(data)
    engine = QMLEngine(state)
    t1 = perf_counter()

    # --- Timed phase 2: Z3 classification. ---
    ItemClassifier(engine.static_builder).classify_all_items()
    t2 = perf_counter()

    stats = engine.get_statistics()
    z3_constraints = stats.get("z3_constraints", {}) if isinstance(stats, dict) else {}

    return {
        "construction_s": t1 - t0,
        "z3_s": t2 - t1,
        "total_s": t2 - t0,
        "rss_mib": _rss_kib_to_mib(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss),
        "achieved_depth": len(engine.topology.get_dependency_layers()),
        "item_count": len(engine.get_items()),
        "z3_constraints_total": z3_constraints.get("total"),
        "z3_variables": stats.get("z3_variables") if isinstance(stats, dict) else None,
    }


def _child_main(argv: list[str]) -> int:
    """Child entry point: measure one QML and print the record as JSON to stdout."""
    if len(argv) != 1:
        print(json.dumps({"error": "usage: python -m benchmark.runner <qml_path>"}))
        return 2
    try:
        record = measure_once(argv[0])
    except Exception as exc:  # surface as a parseable error, never a bare crash
        print(json.dumps({"error": f"{type(exc).__name__}: {exc}"}))
        return 1
    print(json.dumps(record))
    return 0


def run_validation(qml_path: str | Path, timeout_s: float) -> dict[str, Any]:
    """Run one validation in a fresh subprocess under a wall-clock timeout.

    Returns a record with ``status`` one of:
    - ``"ok"``      — measurement fields present.
    - ``"timeout"`` — the child exceeded ``timeout_s`` and was killed.
    - ``"error"``   — the child failed or returned unparseable output.
    """
    try:
        proc = subprocess.run(
            [sys.executable, "-m", "benchmark.runner", str(qml_path)],
            capture_output=True,
            text=True,
            timeout=timeout_s,
            cwd=str(REPO_ROOT),
        )
    except subprocess.TimeoutExpired:
        return {"status": "timeout", "timeout_s": timeout_s}

    if proc.returncode != 0:
        detail = proc.stdout.strip() or proc.stderr.strip()
        return {"status": "error", "detail": detail[:500]}
    try:
        record = json.loads(proc.stdout)
    except json.JSONDecodeError:
        return {"status": "error", "detail": (proc.stdout or proc.stderr)[:500]}
    if "error" in record:
        return {"status": "error", "detail": str(record["error"])[:500]}
    record["status"] = "ok"
    return record


def run_repeated(
    qml_path: str | Path,
    reps: int = 5,
    warmup: int = 1,
    timeout_s: float = 120.0,
) -> dict[str, Any]:
    """Measure a questionnaire over ``warmup`` discarded runs + ``reps`` measured runs.

    Every run (warm-up and measured) spawns its own fresh subprocess — a single
    child never loops internally, which would reintroduce the in-process Z3
    accumulation the subprocess boundary exists to prevent. Aggregates each
    timing/memory metric to median, min, and max. If any run does not complete
    (timeout or error), returns that non-completion record immediately so the
    sweep records the point rather than aborting.
    """
    for _ in range(max(0, warmup)):
        warm = run_validation(qml_path, timeout_s)
        if warm["status"] != "ok":
            return warm  # non-completion even on warm-up -> record it

    samples: list[dict[str, Any]] = []
    for _ in range(max(1, reps)):
        result = run_validation(qml_path, timeout_s)
        if result["status"] != "ok":
            return result
        samples.append(result)

    agg: dict[str, Any] = {"status": "ok", "reps": len(samples)}
    for field in _TIMING_FIELDS:
        values = [s[field] for s in samples]
        agg[f"{field}_median"] = statistics.median(values)
        agg[f"{field}_min"] = min(values)
        agg[f"{field}_max"] = max(values)
    for field in _STRUCTURAL_FIELDS:
        agg[field] = samples[0].get(field)
    return agg


if __name__ == "__main__":
    raise SystemExit(_child_main(sys.argv[1:]))
