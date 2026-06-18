# QML Validator Benchmark Harness

A scaling study of the QML validator: how validation **time** and **memory**
grow with questionnaire **size** and **complexity**. It generates synthetic QML
questionnaires across four axes, validates each in-process while measuring
construction time, isolated Z3-solve time, and peak memory, and renders one PNG
figure per axis.

This is an isolated [uv](https://docs.astral.sh/uv/) project. Its dependencies
(`matplotlib`) and tests live here, never in the repo-root `pyproject.toml` or
`tests/`, both of which the `qml-v*` release-mirror sync overwrites. The
validator (`askalot_qml`) is imported from the repo root as an editable path
dependency and benchmarked as-is — nothing in `askalot_qml` is modified.

## Quick start

```bash
# from the repo root
make benchmark            # fast smoke sweep (all axes) + figures
make benchmark-test       # run the harness's own tests

# or directly
uv run --project benchmark python -m benchmark.sweep --smoke   # writes results/results.json
uv run --project benchmark python -m benchmark.plot            # writes figures/*.png
```

The **paper-grade** run is the same command without `--smoke`:

```bash
uv run --project benchmark python -m benchmark.sweep           # items 10–1000, conditions 10–500, depth 1–25
uv run --project benchmark python -m benchmark.plot
```

## The four sweeps

Each sweep varies one axis while holding the others at a fixed baseline:

| Axis | What varies | Paper-grade range |
|------|-------------|-------------------|
| `items` | number of questions | 10 → 1000 (log-spaced) |
| `preconditions` | number of precondition-gated items | 10 → 500 |
| `postconditions` | number of items carrying a postcondition | 10 → 500 |
| `depth` | precondition-chain length (dependency depth) | 1 → 25 |

Depth and precondition count are not fully independent — a depth-*D* chain
contains *D-1* preconditions — so each row records both the requested and the
*achieved* counts (the achieved depth is read back from the engine's topology).

## What is measured

Each data point runs in a **fresh subprocess** (one per warm-up and per
repetition), which is required for a clean peak-RSS reading: Z3 allocates
natively and does not return memory to the OS until the process exits. Per run,
time is split into three phases:

- **parse time** — `QMLLoader.load_from_path()` (file read, `yaml.safe_load`,
  and the post-parse pipeline: version gate, predicate normalization, kind
  handling). This builds the document the validator consumes and grows with
  questionnaire size — at scale it is 30–50% of end-to-end cost — so it is
  measured rather than excluded as "file I/O".
- **construction time** — `QMLState` + `QMLEngine` (`StaticBuilder` constraint
  generation + `QMLTopology` dependency discovery).
- **Z3 solve time** — `ItemClassifier.classify_all_items()` (the SMT solve),
  isolated so the figure shows where cost comes from.

`total = parse + construction + z3` (summed from the phase deltas, so the
identity is exact). The figure plots **total**, **parse**, and **Z3 solve**.

- **peak memory** — process RSS via `resource.getrusage` (never `tracemalloc`,
  which is blind to Z3's native allocations), normalized to MiB.

A per-run timeout caps pathological cases; a timed-out point is recorded as a
non-completion and drawn distinctly, never dropped.

## CLI options

`benchmark.sweep`:

| Flag | Default | Meaning |
|------|---------|---------|
| `--smoke` | off | Use small smoke ranges instead of paper-grade |
| `--axis {items,preconditions,postconditions,depth,all}` | `all` | Which axis to sweep |
| `--reps N` | 5 | Measured repetitions per point (reported as median + min/max) |
| `--warmup N` | 1 | Discarded warm-up runs per point |
| `--timeout S` | 120 | Per-run wall-clock timeout (seconds) |
| `--seed N` | 12345 | Generator seed (deterministic output) |
| `--regenerate` | off | Overwrite existing `.qml` artifacts (default: **reuse** them) |
| `--out PATH` | `results/results.json` | Results file |
| `--results-dir PATH` | `results/` | Where generated `.qml` artifacts go |

Generated `.qml` files are **reused if already present** — a sweep does not
rewrite `<axis>_<value>.qml` when it exists, since generation is deterministic in
`(axis, value, seed)`. After changing `--seed` or the sweep ranges, pass
`--regenerate` to force fresh artifacts.

`benchmark.plot`: `--results PATH` (default `results/results.json`),
`--figures-dir PATH` (default `figures/`).

## Outputs

- `results/results.json` — provenance header (Python / `z3-solver` /
  `askalot_qml` versions, CPU, seed, reps, timeout) plus one row per point. This
  is the durable artifact; **figures are derived from it**, so re-plotting or
  restyling never re-runs validation.
- `figures/<axis>.png` — one figure per axis.

`results/` is gitignored (re-derivable intermediate). `figures/` is **committed** —
the root [`README.md`](../README.md) embeds those PNGs; refresh them by hand when
Z3 or the harness changes, not on every run.

## Layout

| File | Role |
|------|------|
| `config.py` | Baseline questionnaire + per-axis sweep ranges (paper + smoke) |
| `generator.py` | Parametric synthetic-QML generator |
| `runner.py` | Subprocess-isolated, instrumented single-validation runner |
| `sweep.py` | Sweep driver + raw-results emission + CLI |
| `plot.py` | Raw results → one PNG per axis |
| `tests/` | Harness test suite (`make benchmark-test`) |
