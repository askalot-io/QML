"""
The static verdicts never claim more than the runtime does, on generated questionnaires.

Tests the soundness of ``ValidationProcessor``'s verdicts against the real
runtime (``FlowProcessor``), over questionnaires ``tests/helpers/soundness_fuzz``
generates from a seed (2-4 items mixing text and numbers in answers, variables,
matrix cells and rows, codeInit and codeBlock stores, conditions comparing them):
- no item the validator calls NEVER (or ``unreachable_item``) is reached by a walk
- no postcondition it calls INFEASIBLE is met by an answer a walk gives
- no item it calls ALWAYS is skipped by a walk, unless it says the verdict is
  withheld (an inexact or skipped condition, an unbound name, a cycle)
- a fixed CI set of seeds, plus every seed that found a counterexample on an
  earlier head of #2243
- ``QML_SOUNDNESS_FUZZ_CASES`` widens the range for a local run

These integration tests walk every combination of a small answer domain per
item through the runtime, on a copy of the state at each branch, so the ground
truth is what a respondent can actually reach, not a model of it. Each
counterexample is also written out as a named test in
``test_validation_to_issues.py``.
"""

import os

import pytest

from tests.helpers.soundness_fuzz import check

#: Seeds that found a counterexample on the round-6 head of #2243 (row stores,
#: an encoded variable against a value that may hold text, orderings of what
#: may hold text).
_FOUND = [
    910, 1122, 1251, 1324, 1650, 3010, 3967, 4277, 5060, 5460, 5483, 5908, 6962, 7330, 7832, 8133, 8888, 9092, 12175,
    12625, 13566, 15392, 15419, 16957, 17539, 17809, 17924, 18106, 18330, 18732, 18905, 18912,
]

_CASES = int(os.environ.get("QML_SOUNDNESS_FUZZ_CASES", "200"))


@pytest.mark.parametrize("seed", sorted(set(range(_CASES)) | set(_FOUND)))
def test_the_static_verdicts_hold_on_every_walk(seed):
    """Every verdict the validator gives on case ``seed`` holds on every walk
    of the runtime over the answers it tries."""
    assert check(seed) == []
