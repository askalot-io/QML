"""
ItemProxy — runtime accessor for a single questionnaire item.

The proxy exposes input properties (min/max/labels/control/...) and the user's
answer (`self.outcome`) to QML-author code blocks, preconditions, and
postconditions. Native shapes only — see the per-kind contract below.

Outcome contract (plan 2026-05-05-001):

| Kind            | Shape                                |
|-----------------|--------------------------------------|
| Question        | bare scalar (int|float|str|bool|None) — Checkbox: bitmask int; Range: a Range cell |
| QuestionGroup   | List[Any], one cell per entry of the item's `questions` — Range: a list of Range cells |
| MatrixQuestion  | List[List[Any]] sized by the item's `rows` × `columns` — Range: rows × cols of Range cells |
| Comment         | None                                 |

A **Range cell** is `None` or a `RangeValue` (#1755, D89): conditions and
codeBlocks read its ends by name, `q.outcome.low` / `q.outcome.high`, and in a
matrix `m.outcome[r][c].low`. There is no positional alias: `q.outcome[0]`
raises, naming `.low` / `.high`. Storage keeps the pair `[low, high]` of two
finite numbers with `low <= high` (#1474): each end is coerced like a scalar
(`["2", "8"]` → `low=2, high=8`), but a cell is never built from anything else:
a scalar, a one- or three-item list, a non-numeric or missing end, or
`low > high` raises ValueError naming the item. The input boundaries (the
browser control, the fills, the respondent lane) produce the pair; this proxy
is the one gate every stored value passes. `low <= high` is part of the
shape, not the domain (`min`/`max` is `domain_validator`'s: `outcome_in_domain` for
prefill, `answer_refusal` for every answer, #1757).

**The `outcome` setter holds the read shape** for a Range item whoever assigns
it: a codeBlock's `q.outcome = [a, b]` (the one Range write form) becomes a
`RangeValue` at once, so the block can read `q.outcome.low` next, and a
malformed pair is refused at the write. Roster `outcomes[K]` cells read the
same way for every Range kind. **`to_outcome()` is the storage shape**, and
every write-back goes through it, the Roster snapshot included, so a dataclass
never reaches `qml_state`.

`from_outcome` rejects legacy dict shapes (`{"_": v}`, `{"_0": v}`,
`{"_0_0": v}`) with ValueError — feedback_no_silent_fallbacks. Callers
that produce a list for a Checkbox Question are also rejected; the
input-boundary parser (Portor llm_respondent / frontend CheckboxControl)
owns the list→bitmask reduction, so by the time data reaches ItemProxy
the canonical bitmask int is already present.

A MatrixQuestion also exposes its declared `rows` and `columns`, and a
QuestionGroup its `questions`, as tuples (#1782), so `range(len(m.rows))`
evaluates to what the Z3 builder unrolled.

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
        self._item = item  # Retained for shape validation (questions, rows, columns: item keys).

        # The declared lists, read-only, on the kind that declares them (#1782):
        # ``range(len(m.rows))`` in a condition reads what the Z3 builder
        # unrolled at build time (``_DECLARED_LIST_LENGTHS``).
        if self.kind == "MatrixQuestion":
            self.rows = tuple(item.get("rows") or ())
            self.columns = tuple(item.get("columns") or ())
        elif self.kind == "QuestionGroup":
            self.questions = tuple(item.get("questions") or ())

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

        self.from_outcome(self.raw_outcome)

        # Roster outside-read accessor (unchanged from the prior format).
        roster_block_id = item.get("_roster_block_id")
        if roster_block_id and roster_outcomes_for_block is not None:
            self.outcomes = {
                label_key: (
                    self._map_range_cells(per_iter.get(self.id), self._range_cell)
                    if self._is_range()
                    else per_iter.get(self.id)
                )
                for label_key, per_iter in roster_outcomes_for_block.items()
                if self.id in per_iter
            }

    def __repr__(self):
        return f"<ItemProxy id={self.id} outcome={self.outcome}>"

    @property
    def outcome(self) -> Any:
        return self._outcome

    @outcome.setter
    def outcome(self, value: Any) -> None:
        """A Range item holds its read shape whoever assigns it.

        The proxy's own setters assign ``RangeValue`` cells already; a codeBlock
        assigns the write form, ``q.outcome = [a, b]``. Converting here means
        the same block can read ``q.outcome.low`` straight after writing, and a
        malformed pair is refused at the write, inside the block that made it.
        """
        self._check_list_shape(value)
        self._outcome = (
            self._map_range_cells(value, self._range_cell) if self._is_range() else value
        )

    def _check_list_shape(self, value: Any) -> None:
        """Refuse a group or matrix value whose shape is not the item's (#1616).

        Here, at the write, so a codeBlock that assigns ``m.outcome = [[1, 2]]``
        to a 3 x 2 matrix fails in that block (a ``critical`` codeblock warning)
        instead of being stored and then refused by every later proxy build.
        """
        if not isinstance(value, list):
            return
        from askalot_qml.core.controls import answer_shape

        shape = answer_shape(self._item)
        if shape is None:
            return
        if self.kind == "QuestionGroup" and len(value) > shape[0]:
            raise ValueError(
                f"QuestionGroup outcome list length {len(value)} exceeds its "
                f"{shape[0]} questions for item {self.id!r}"
            )
        if self.kind == "MatrixQuestion" and (
            len(value) != shape[0]
            or any(not isinstance(row, list) or len(row) != shape[1] for row in value)
        ):
            raise ValueError(
                f"MatrixQuestion outcome is not {shape[0]} rows of {shape[1]} cells "
                f"for item {self.id!r}"
            )

    def _map_range_cells(self, value: Any, cell: Any) -> Any:
        """Apply ``cell(value, where)`` to every Range cell of a ``value`` shaped like this kind."""
        if value is None:
            return None
        if self.kind == "Question":
            return cell(value, "")
        if self.kind == "QuestionGroup" and isinstance(value, list):
            return [cell(v, f" at position {i}") for i, v in enumerate(value)]
        if self.kind == "MatrixQuestion" and isinstance(value, list):
            return [
                [cell(v, f" at row {r}, column {c}") for c, v in enumerate(row)]
                if isinstance(row, list)
                else row
                for r, row in enumerate(value)
            ]
        return value

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
        if self._is_range():
            self.outcome = outcome  # the setter turns it into a RangeValue
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
        # The sub-questions are the item's own ``questions`` list (#1616); a
        # Group has no ``input.count`` (``count`` is a Block property).
        from askalot_qml.core.controls import answer_shape

        shape = answer_shape(self._item)
        count = shape[0] if shape else None
        if count is not None and len(outcome) > count:
            raise ValueError(
                f"QuestionGroup outcome list length {len(outcome)} exceeds its "
                f"{count} questions for item {self.id!r}"
            )
        # A Range cell is left to the setter, which turns each into a RangeValue.
        coerced: list[Any] = (
            list(outcome) if self._is_range() else [self._coerce_outcome(v) for v in outcome]
        )
        # Pad short lists with None, one cell per question.
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
        # ``rows`` / ``columns`` sit on the item, not under ``input`` (#1616).
        from askalot_qml.core.controls import answer_shape

        shape = answer_shape(self._item)
        expected_rows, expected_cols = shape if shape else (None, None)
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
        if self._is_range():
            self.outcome = outcome  # the setter turns each cell into a RangeValue
            return
        self.outcome = [[self._coerce_outcome(v) for v in row] for row in outcome]

    def _is_range(self) -> bool:
        return getattr(self, "control", None) == "Range"

    def _range_cell(self, value: Any, where: str) -> Any:
        """One Range cell as conditions read it: None, or a ``RangeValue``.

        Delegates the shape to ``core.controls.range_value`` (shared with the
        domain validator's ``range_pair``), imported function-locally for the
        same cycle reason as ``_coerce_outcome``.
        """
        if value is None:
            return None
        from askalot_qml.core.controls import RangeValue, range_value

        if isinstance(value, RangeValue):
            return value
        try:
            return range_value(value)
        except ValueError as exc:
            raise ValueError(f"{exc} for item {self.id!r}{where}") from None

    def _stored_range_cell(self, value: Any, where: str) -> list[int | float] | None:
        """One Range cell in its stored shape, ``[low, high]`` or None.

        A cell the ``outcome`` setter converted is a checked ``RangeValue``
        already. One a codeBlock wrote in place (``qg.outcome[i] = [a, b]``,
        ``m.outcome[r][c] = [a, b]``) never passed the setter, so it goes
        through ``_range_cell`` here: the shape rule holds on every write-back.
        """
        cell = self._range_cell(value, where)
        return None if cell is None else cell.as_pair()

    def _coerce_outcome(self, value: Any) -> Any:
        """
        Coerce string values to int or float for non-text controls. JSON / MCP
        serialization can turn numeric outcomes into strings (e.g., "7" instead
        of 7), causing precondition comparisons like `q_age.outcome >= 18` to
        fail with TypeError. Textarea controls preserve string outcomes.

        Delegates to the shared ``core.controls.coerce_scalar`` — the single
        definition of this coercion, also used by the external-input domain
        validator, so the two never drift. Imported function-locally: a
        top-level import would form a cycle (``models.item_proxy`` ->
        ``core.controls`` -> ``core.__init__`` -> ``core.flow_processor`` ->
        ``models.item_proxy``) when ``models`` is imported before ``core``.
        """
        from askalot_qml.core.controls import coerce_scalar

        return coerce_scalar(value, getattr(self, "control", None))

    def to_outcome(self) -> Any | None:
        """The outcome in its storage shape.

        Every write-back funnels through here (codeInit and codeBlock
        propagation, the Roster snapshot and restore), so the one shape change
        between reading and storing lives here: a Range cell is read as a
        ``RangeValue`` and stored as ``[low, high]``. Any other item is
        returned as the proxy holds it, except that a ``RangeValue`` a codeBlock
        assigned to it (``other.outcome = q.outcome``) is stored as its pair.
        """
        if not self._is_range():
            from askalot_qml.core.controls import stored_shape

            return stored_shape(self.outcome)
        return self._map_range_cells(self.outcome, self._stored_range_cell)
