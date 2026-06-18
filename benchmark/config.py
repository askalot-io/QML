"""Sweep configuration: baselines and per-axis ranges.

Each :class:`SweepSpec` varies ONE axis across a range while holding the other
three at a fixed baseline. The baseline differs per axis only as needed to host
the swept range (e.g. the precondition sweep needs enough items to carry 500
preconditions); within a single sweep, only the named axis changes, which is
what isolates its effect in the figure.

Two modes:

- ``paper`` — the paper-grade ranges (items ~10->1000 log-spaced,
  preconditions/postconditions ~10->500, depth ~1->25).
- ``smoke`` — tiny ranges for the fast end-to-end path (``make benchmark``).
"""

from __future__ import annotations

from dataclasses import dataclass

from benchmark.generator import GenConfig

DEFAULT_SEED = 12345

# axis name -> the GenConfig field it varies
AXIS_TO_PARAM: dict[str, str] = {
    "items": "n_items",
    "preconditions": "n_preconditions",
    "postconditions": "n_postconditions",
    "depth": "depth",
}
AXES: tuple[str, ...] = tuple(AXIS_TO_PARAM)


@dataclass(frozen=True)
class SweepSpec:
    """One axis sweep: ``values`` of ``axis`` over a fixed ``baseline`` of the rest."""

    axis: str
    values: tuple[int, ...]
    baseline: dict[str, int]  # fixed GenConfig fields for the non-swept axes

    def config_for(self, value: int, seed: int) -> GenConfig:
        params = dict(self.baseline)
        params[AXIS_TO_PARAM[self.axis]] = value
        return GenConfig(seed=seed, **params)


# Paper-grade sweeps (plan R10). Item count is log-spaced; the structural axes
# (preconditions/postconditions) hold n_items high enough to host 500 of them.
_PAPER: dict[str, SweepSpec] = {
    "items": SweepSpec(
        axis="items",
        values=(10, 20, 50, 100, 200, 500, 1000),
        baseline={"n_preconditions": 0, "n_postconditions": 0, "depth": 1},
    ),
    "preconditions": SweepSpec(
        axis="preconditions",
        values=(10, 50, 100, 200, 350, 500),
        baseline={"n_items": 600, "n_postconditions": 0, "depth": 1},
    ),
    "postconditions": SweepSpec(
        axis="postconditions",
        values=(10, 50, 100, 200, 350, 500),
        baseline={"n_items": 600, "n_preconditions": 0, "depth": 1},
    ),
    "depth": SweepSpec(
        axis="depth",
        values=(1, 2, 4, 8, 12, 16, 20, 25),
        baseline={"n_items": 50, "n_preconditions": 0, "n_postconditions": 0},
    ),
}

# Smoke sweeps: a few cheap points per axis for the end-to-end wiring check.
_SMOKE: dict[str, SweepSpec] = {
    "items": SweepSpec(
        axis="items",
        values=(10, 50, 100),
        baseline={"n_preconditions": 0, "n_postconditions": 0, "depth": 1},
    ),
    "preconditions": SweepSpec(
        axis="preconditions",
        values=(10, 30, 60),
        baseline={"n_items": 80, "n_postconditions": 0, "depth": 1},
    ),
    "postconditions": SweepSpec(
        axis="postconditions",
        values=(10, 30, 60),
        baseline={"n_items": 80, "n_preconditions": 0, "depth": 1},
    ),
    "depth": SweepSpec(
        axis="depth",
        values=(1, 3, 6),
        baseline={"n_items": 20, "n_preconditions": 0, "n_postconditions": 0},
    ),
}


def sweeps(mode: str) -> dict[str, SweepSpec]:
    """Return the ``{axis: SweepSpec}`` map for ``mode`` ('paper' or 'smoke')."""
    if mode == "paper":
        return dict(_PAPER)
    if mode == "smoke":
        return dict(_SMOKE)
    raise ValueError(f"unknown sweep mode {mode!r} (expected 'paper' or 'smoke')")
