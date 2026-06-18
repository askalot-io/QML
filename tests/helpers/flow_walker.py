"""
Shared FlowProcessor drive-and-answer helper for integration tests.

Extracted from the duplicated per-file walk drivers that existed in
test_group_traversal.py and test_group_e2e_chain.py.

The e2e walker in e2e-tests/ is an instance method on its chain class for
graceful-skip compatibility (the class is conditionally skipped when
askalot_qml is not importable). That hard dependency on `self` makes it
structurally divergent from this module-level function, so the e2e copy is
intentionally not merged here. Both helpers are functionally equivalent.
"""

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.models.qml_state import QMLState


def walk_and_answer(
    processor: FlowProcessor,
    state: QMLState,
    answer_for: dict,
    max_steps: int = 200,
) -> list[str]:
    """Drive the FlowProcessor forward, answering each presented item.

    Returns the ordered list of item_ids the processor presented (the
    user-visible step sequence). The terminal isLast recap redisplay is
    dropped — it is not a new presentation.

    Raises AssertionError if:
    - the processor hands the test an item with no mapped answer, or
    - more than max_steps items are presented (likely a loop).
    """
    walked: list[str] = []
    for _step in range(max_steps):
        item = processor.get_current_item(state, backward=False)
        if item is None:
            break
        if item.get("isLast"):
            break
        item_id = item["id"]
        walked.append(item_id)
        if item_id not in answer_for:
            raise AssertionError(
                f"Test fixture has no answer for {item_id!r}; walked so far: {walked!r}"
            )
        result = processor.process_item(state, item_id, answer_for[item_id])
        assert result.get("success"), f"process_item failed for {item_id}: {result}"
    else:
        raise AssertionError(f"Walked >{max_steps} items — likely a loop: {walked!r}")
    return walked
