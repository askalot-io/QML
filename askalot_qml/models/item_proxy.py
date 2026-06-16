"""
ItemProxy — runtime accessor for a single questionnaire item.

The proxy exposes input properties (min/max/labels/control/...) and the user's
answer (`self.outcome`) to QML-author code blocks, preconditions, and
postconditions. Native shapes only — see the per-kind contract below.

Outcome contract (plan 2026-05-05-001):

| Kind            | Shape                                |
|-----------------|--------------------------------------|
| Question        | bare scalar (int|float|str|bool|None) — Checkbox: bitmask int |
| QuestionGroup   | List[Any] of length input.count      |
| MatrixQuestion  | List[List[Any]] sized rows × cols    |
| Comment         | None                                 |

`from_outcome` rejects legacy dict shapes (`{"_": v}`, `{"_0": v}`,
`{"_0_0": v}`) with ValueError — feedback_no_silent_fallbacks. Callers
that produce a list for a Checkbox Question are also rejected; the
input-boundary parser (Portor llm_respondent / frontend CheckboxControl)
owns the list→bitmask reduction, so by the time data reaches ItemProxy
the canonical bitmask int is already present.

Roster outside-read accessor: items tagged `_roster_block_id` get a dict-
shaped `outcomes` attribute keyed by label_key (the bit value 1, 2, 4,
8, …). Inner-roster code reads `q.outcome` (singular) via the
FlowProcessor's snapshot/restore layer — not via this proxy.
"""

from typing import Any


class ItemProxy:
    def __init__(
        self,
        item: dict[str, Any],
        roster_outcomes_for_block: dict[int, dict[str, Any]] | None = None,
    ):
        self.id = item.get("id")
        self.raw_outcome = item.get("outcome")
        self.kind = item.get("kind")
        self._item = item  # Retained for shape validation (rows/columns/count).

        # Extract input configuration BEFORE from_outcome so control type and
        # count/rows/cols are available for shape validation and coercion.
        self.input_props: dict[str, Any] = {}
        input_config = item.get("input", {})

        for prop in ["min", "max", "step", "default", "left", "right", "on", "off", "count"]:
            if prop in input_config:
                self.input_props[prop] = input_config[prop]
                setattr(self, prop, input_config[prop])

        if "labels" in input_config:
            self.labels = input_config["labels"]
            self.input_props["labels"] = input_config["labels"]

        if "control" in input_config:
            self.control = input_config["control"]
            self.input_props["control"] = input_config["control"]

        if "rows" in input_config:
            self.input_props["rows"] = input_config["rows"]
        if "columns" in input_config:
            self.input_props["columns"] = input_config["columns"]

        self.from_outcome(self.raw_outcome)

        # Roster outside-read accessor (unchanged from the prior format).
        roster_block_id = item.get("_roster_block_id")
        if roster_block_id and roster_outcomes_for_block is not None:
            self.outcomes = {
                label_key: per_iter.get(self.id)
                for label_key, per_iter in roster_outcomes_for_block.items()
                if self.id in per_iter
            }

    def __repr__(self):
        return f"<ItemProxy id={self.id} outcome={self.outcome}>"

    def from_outcome(self, outcome: Any) -> None:
        """
        Set self.outcome from the native-shape outcome value. Raises ValueError
        on shape mismatch, including any legacy dict shape from the pre-refactor
        format — there is no silent unwrap path.
        """
        if self.kind == "Question":
            self._set_question_outcome(outcome)
        elif self.kind == "QuestionGroup":
            self._set_question_group_outcome(outcome)
        elif self.kind == "MatrixQuestion":
            self._set_matrix_outcome(outcome)
        elif self.kind == "Comment":
            # Comments never carry an answer.
            self.outcome = None
        else:
            # Unknown kinds pass through with a None outcome — defensive.
            self.outcome = None

    def _set_question_outcome(self, outcome: Any) -> None:
        if outcome is None:
            self.outcome = None
            return
        if isinstance(outcome, (bool, int, float, str)):
            self.outcome = self._coerce_outcome(outcome)
            return
        raise ValueError(
            f"Question outcome must be scalar (int|float|str|bool|None); "
            f"got {type(outcome).__name__} for item {self.id!r}"
        )

    def _set_question_group_outcome(self, outcome: Any) -> None:
        if outcome is None:
            self.outcome = None
            return
        if not isinstance(outcome, list):
            raise ValueError(
                f"QuestionGroup outcome must be a list; got "
                f"{type(outcome).__name__} for item {self.id!r}"
            )
        count = self.input_props.get("count")
        if count is not None and len(outcome) > count:
            raise ValueError(
                f"QuestionGroup outcome list length {len(outcome)} exceeds "
                f"input.count={count} for item {self.id!r}"
            )
        coerced: list[Any] = [self._coerce_outcome(v) for v in outcome]
        # Pad short lists with None to reach input.count.
        if count is not None and len(coerced) < count:
            coerced.extend([None] * (count - len(coerced)))
        self.outcome = coerced

    def _set_matrix_outcome(self, outcome: Any) -> None:
        if outcome is None:
            self.outcome = None
            return
        if not isinstance(outcome, list) or not all(isinstance(r, list) for r in outcome):
            raise ValueError(
                f"MatrixQuestion outcome must be List[List[Any]]; got "
                f"{type(outcome).__name__} for item {self.id!r}"
            )
        rows = self.input_props.get("rows")
        cols = self.input_props.get("columns")
        expected_rows = len(rows) if isinstance(rows, list) else None
        expected_cols = len(cols) if isinstance(cols, list) else None
        if expected_rows is not None and len(outcome) != expected_rows:
            raise ValueError(
                f"MatrixQuestion outcome row count {len(outcome)} does not match "
                f"expected {expected_rows} for item {self.id!r}"
            )
        for r_idx, row in enumerate(outcome):
            if expected_cols is not None and len(row) != expected_cols:
                raise ValueError(
                    f"MatrixQuestion outcome row {r_idx} has {len(row)} cells; "
                    f"expected {expected_cols} for item {self.id!r}"
                )
        self.outcome = [[self._coerce_outcome(v) for v in row] for row in outcome]

    # Controls where string outcomes are intentional (open-ended text input).
    _TEXT_CONTROLS = frozenset({"textarea"})

    def _coerce_outcome(self, value: Any) -> Any:
        """
        Coerce string values to int or float for non-text controls. JSON / MCP
        serialization can turn numeric outcomes into strings (e.g., "7" instead
        of 7), causing precondition comparisons like `q_age.outcome >= 18` to
        fail with TypeError. Textarea controls preserve string outcomes.
        """
        if not isinstance(value, str):
            return value
        control = getattr(self, "control", None)
        if control and control.lower() in self._TEXT_CONTROLS:
            return value
        try:
            return int(value)
        except (ValueError, TypeError):
            pass
        try:
            return float(value)
        except (ValueError, TypeError):
            pass
        return value

    def to_outcome(self) -> Any | None:
        """
        Trivial accessor returning self.outcome. Kept as a single-point method
        so any future shape-contract change happens in one file (FlowProcessor's
        snapshot/restore round-trip and codeBlock outcome propagation both
        funnel through here).
        """
        return self.outcome
