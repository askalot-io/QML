# QML Validator Benchmark Harness

A scaling study of the QML validator: how validation **time** and **memory**
grow with questionnaire **size** and **complexity**. It generates synthetic
QML questionnaires across four axes, validates each in-process while measuring
construction time, isolated Z3-solve time, and peak memory, and renders one PNG
figure per axis.

This is an isolated [uv](https://docs.astral.sh/uv/) project. Its dependencies
(`matplotlib`) and tests live here, never in the repo-root `pyproject.toml` or
`tests/`, both of which the `qml-v*` release-mirror sync overwrites. The
validator (`askalot_qml`) is imported from the repo root as an editable path
dependency and benchmarked as-is.

## Quick start

```bash
# from the repo root
make benchmark            # fast smoke sweep + figures
make benchmark-test       # run the harness's own tests

# or directly
uv run --project benchmark python -m benchmark.sweep --smoke
uv run --project benchmark python -m benchmark.plot
```

Full usage (axes, ranges, repetitions, paper-grade runs) is documented once the
sweep and plot units land — see `make help`.

## Layout

| File | Role |
|------|------|
| `config.py` | Baseline questionnaire + per-axis sweep ranges |
| `generator.py` | Parametric synthetic-QML generator |
| `runner.py` | Subprocess-isolated, instrumented single-validation runner |
| `sweep.py` | Sweep driver + raw-results emission + CLI |
| `plot.py` | Raw results → one PNG per axis |
| `results/` | Generated `.qml` artifacts + raw results (gitignored) |
| `figures/` | Output PNGs (gitignored) |
