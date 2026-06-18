"""Tests for the parametric QML generator.

These load each generated questionnaire through the real validator pipeline
(``QMLLoader`` -> ``QMLState`` -> ``QMLEngine`` -> ``ItemClassifier``) so the
assertions are about what the validator actually observes, not just the emitted
text.
"""

from __future__ import annotations

from pathlib import Path

import pytest

from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier

from benchmark.generator import GenConfig, build_questionnaire, to_yaml, write_qml


def _engine_for(cfg: GenConfig, tmp_path: Path):
    """Generate, write, load schema-less, and build the engine. Returns (engine, stats, doc)."""
    qml_path = tmp_path / "bench.qml"
    doc, stats = build_questionnaire(cfg)
    qml_path.write_text(to_yaml(doc), encoding="utf-8")
    # schema_path=None mirrors the integration-test load path; schema validation
    # is parse-time work, excluded from the benchmark's timed region.
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(qml_path))
    return QMLEngine(QMLState(data)), stats, doc


def _count_conditions(doc, key: str) -> int:
    items = doc["questionnaire"]["blocks"][0]["items"]
    return sum(1 for item in items if item.get(key))


def test_loads_and_item_count(tmp_path):
    cfg = GenConfig(n_items=8, n_preconditions=5, n_postconditions=4, depth=3)
    engine, stats, _ = _engine_for(cfg, tmp_path)
    assert len(engine.get_items()) == 8
    assert stats.achieved_items == 8


@pytest.mark.parametrize("depth", [1, 2, 5, 10])
def test_depth_matches_dependency_layers(tmp_path, depth):
    # Pure chain (no surplus preconditions) so achieved depth == chain length.
    cfg = GenConfig(n_items=depth, depth=depth)
    engine, stats, _ = _engine_for(cfg, tmp_path)
    layers = engine.topology.get_dependency_layers()
    assert stats.achieved_depth == depth
    assert len(layers) == depth


def test_surplus_preconditions_stay_shallow(tmp_path):
    # depth=1 (no chain) but many preconditions on the root -> exactly 2 layers.
    cfg = GenConfig(n_items=50, n_preconditions=20, depth=1)
    engine, stats, _ = _engine_for(cfg, tmp_path)
    assert stats.achieved_depth == 2
    assert len(engine.topology.get_dependency_layers()) == 2


def test_condition_counts_present(tmp_path):
    cfg = GenConfig(n_items=30, n_preconditions=12, n_postconditions=7, depth=4)
    _, stats, doc = _engine_for(cfg, tmp_path)
    assert _count_conditions(doc, "precondition") == stats.achieved_preconditions
    assert _count_conditions(doc, "postcondition") == stats.achieved_postconditions
    # depth=4 chain contributes 3; 12 requested -> 9 surplus -> 12 total.
    assert stats.achieved_preconditions == 12
    assert stats.achieved_postconditions == 7


def test_deterministic_under_seed():
    cfg_a = GenConfig(n_items=40, n_preconditions=10, n_postconditions=10, depth=3, seed=7)
    cfg_b = GenConfig(n_items=40, n_preconditions=10, n_postconditions=10, depth=3, seed=7)
    cfg_c = GenConfig(n_items=40, n_preconditions=10, n_postconditions=10, depth=3, seed=8)
    doc_a, _ = build_questionnaire(cfg_a)
    doc_b, _ = build_questionnaire(cfg_b)
    doc_c, _ = build_questionnaire(cfg_c)
    assert to_yaml(doc_a) == to_yaml(doc_b)
    # Different seed shuffles which items carry decorations -> different text.
    assert to_yaml(doc_a) != to_yaml(doc_c)


def test_generated_questionnaire_is_satisfiable(tmp_path):
    cfg = GenConfig(n_items=20, n_preconditions=8, n_postconditions=6, depth=4)
    engine, _, _ = _engine_for(cfg, tmp_path)
    classifications = ItemClassifier(engine.static_builder).classify_all_items()
    # No item's postcondition should be INFEASIBLE (would mean we generated an
    # unsatisfiable constraint and the validator is exercising an error path).
    for key, result in classifications.items():
        if isinstance(result, dict):
            postcond = result.get("postcondition")
            if isinstance(postcond, dict):
                assert postcond.get("invariant") != "INFEASIBLE", f"{key} postcondition INFEASIBLE"


def test_write_qml_roundtrips(tmp_path):
    cfg = GenConfig(n_items=5, depth=2)
    stats = write_qml(cfg, tmp_path / "out.qml")
    assert (tmp_path / "out.qml").exists()
    assert stats.achieved_items == 5


def test_guards_reject_impossible_configs():
    with pytest.raises(ValueError):
        GenConfig(n_items=3, depth=5)  # depth > n_items
    with pytest.raises(ValueError):
        GenConfig(n_items=4, n_postconditions=9)  # postconditions > n_items
    with pytest.raises(ValueError):
        GenConfig(n_items=5, n_preconditions=10, depth=1)  # surplus > non-chain items
