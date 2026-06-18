"""Parametric synthetic-QML generator for the validator scaling study.

The generator emits well-formed, satisfiable QML 2.0 questionnaires whose size
and complexity are controlled by four knobs:

- ``n_items``         total number of items (each a Radio question).
- ``depth``           length of a precondition *chain* among the first ``depth``
                      items, which is what the validator's topology turns into
                      dependency layers (``len(get_dependency_layers()) == depth``
                      for ``depth >= 2``).
- ``n_preconditions`` number of precondition-bearing items. The chain already
                      contributes ``depth - 1``; any surplus is attached to
                      non-chain items as a single ``q0.outcome == 1`` gate
                      (referencing the chain root, so it adds breadth at layer 1
                      without deepening the chain).
- ``n_postconditions`` number of items carrying a self-referential postcondition
                      (``q.outcome >= 1``); self-references are excluded from the
                      dependency graph, so postconditions add solver work without
                      changing depth.

All outcomes are integers in ``{1, 2}`` (Radio with labels ``{1, 2}``), so every
chain link ``qK.outcome == 1`` and every postcondition ``q.outcome >= 1`` is
satisfiable — validation exercises the full classification path rather than
exiting on a structural error.

Depth and precondition count are not fully independent: a depth-*D* chain
inherently contains *D-1* preconditions. The generator records the *achieved*
counts (see :class:`GenStats`) alongside the requested ones; the runner reads
the achieved depth back from the engine's topology.
"""

from __future__ import annotations

import random
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

QML_VERSION = "2.0"
# Radio outcome domain. Chain links compare ``== 1`` and postconditions assert
# ``>= 1``; both hold for a value in this set, keeping every questionnaire
# satisfiable by construction.
_RADIO_LABELS = {1: "Option A", 2: "Option B"}


@dataclass(frozen=True)
class GenConfig:
    """Knobs for one generated questionnaire."""

    n_items: int
    n_preconditions: int = 0
    n_postconditions: int = 0
    depth: int = 1
    seed: int = 0
    title: str = "Benchmark Questionnaire"

    def __post_init__(self) -> None:
        if self.n_items < 1:
            raise ValueError(f"n_items must be >= 1 (got {self.n_items})")
        if self.depth < 1:
            raise ValueError(f"depth must be >= 1 (got {self.depth})")
        if self.depth > self.n_items:
            raise ValueError(
                f"depth ({self.depth}) cannot exceed n_items ({self.n_items}): "
                f"a depth-D precondition chain needs at least D items."
            )
        if self.n_postconditions > self.n_items:
            raise ValueError(
                f"n_postconditions ({self.n_postconditions}) cannot exceed "
                f"n_items ({self.n_items})."
            )
        # The chain contributes depth-1 preconditions; any surplus rides on
        # non-chain items, of which there are n_items - depth.
        surplus = max(0, self.n_preconditions - max(0, self.depth - 1))
        non_chain = self.n_items - self.depth
        if surplus > non_chain:
            raise ValueError(
                f"n_preconditions ({self.n_preconditions}) needs {surplus} "
                f"precondition(s) beyond the depth-{self.depth} chain, but only "
                f"{non_chain} non-chain item(s) are available. Increase n_items."
            )


@dataclass(frozen=True)
class GenStats:
    """Analytically-known properties of a generated questionnaire.

    The runner reads the *achieved* values back from the engine; tests compare
    the two. ``achieved_*`` are what the validator should observe given the
    structure the generator emitted.
    """

    requested: GenConfig
    achieved_items: int
    achieved_preconditions: int
    achieved_postconditions: int
    achieved_depth: int


def _item(item_id: str) -> dict[str, Any]:
    return {
        "id": item_id,
        "kind": "Question",
        "title": item_id,
        "input": {"control": "Radio", "labels": dict(_RADIO_LABELS)},
    }


def build_questionnaire(cfg: GenConfig) -> tuple[dict[str, Any], GenStats]:
    """Build the nested QML document and its analytic stats.

    Returns ``(doc, stats)`` where ``doc`` is the full
    ``{"qmlVersion", "questionnaire"}`` mapping ready to serialize, and ``stats``
    records the achieved item / precondition / postcondition / depth counts.
    """
    rng = random.Random(cfg.seed)

    items = [_item(f"q{i}") for i in range(cfg.n_items)]

    # --- Depth: a precondition chain over the first `depth` items. ---
    # q1..q{depth-1} each gate on the previous item's outcome, producing
    # `depth` dependency layers.
    chain_preconditions = 0
    for k in range(1, cfg.depth):
        items[k]["precondition"] = [{"predicate": f"q{k - 1}.outcome == 1"}]
        chain_preconditions += 1

    # --- Extra preconditions: gate surplus non-chain items on the chain root. ---
    # Referencing q0 keeps them at dependency layer 1 (no deepening). Choose
    # which non-chain items receive them via the seeded RNG for reproducibility.
    surplus = max(0, cfg.n_preconditions - chain_preconditions)
    non_chain_indices = list(range(cfg.depth, cfg.n_items))
    rng.shuffle(non_chain_indices)
    extra_pre_indices = non_chain_indices[:surplus]
    for idx in extra_pre_indices:
        items[idx]["precondition"] = [{"predicate": "q0.outcome == 1"}]
    achieved_preconditions = chain_preconditions + len(extra_pre_indices)

    # --- Postconditions: self-referential, independent of depth/preconditions. ---
    post_indices = list(range(cfg.n_items))
    rng.shuffle(post_indices)
    post_indices = post_indices[: cfg.n_postconditions]
    for idx in post_indices:
        item_id = items[idx]["id"]
        items[idx]["postcondition"] = [{"predicate": f"{item_id}.outcome >= 1"}]

    # Achieved depth: the chain gives `depth` layers; surplus preconditions on
    # the root add a layer-1 tier, so a flat (depth==1) questionnaire with any
    # surplus precondition reaches 2 layers.
    achieved_depth = max(cfg.depth, 2 if surplus > 0 else 1)

    doc = {
        "qmlVersion": QML_VERSION,
        "questionnaire": {
            "title": cfg.title,
            "blocks": [{"id": "benchmark", "kind": "Group", "items": items}],
        },
    }
    stats = GenStats(
        requested=cfg,
        achieved_items=cfg.n_items,
        achieved_preconditions=achieved_preconditions,
        achieved_postconditions=len(post_indices),
        achieved_depth=achieved_depth,
    )
    return doc, stats


def to_yaml(doc: dict[str, Any]) -> str:
    """Serialize a questionnaire document to QML (YAML) text."""
    return yaml.safe_dump(doc, sort_keys=False, allow_unicode=True)


def write_qml(cfg: GenConfig, path: str | Path) -> GenStats:
    """Generate a questionnaire and write it to ``path`` as a ``.qml`` file.

    Returns the analytic :class:`GenStats`. The file is what the runner loads;
    the stats are recorded alongside the measurement.
    """
    doc, stats = build_questionnaire(cfg)
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(to_yaml(doc), encoding="utf-8")
    return stats
