"""
Byte-identity tests for the text-preserving QML key splicer.

Tests ``askalot_qml/core/qml_splice.py``:
- setting a key inserts exactly one line and leaves every other byte identical —
  comments, quoting styles and block scalars included (#373)
- the insert anchors to the end of the last pair's physical line, so a trailing
  comment keeps its subject instead of being orphaned onto the new key
- an existing value is retargeted over its whole span, quoting included, while an
  already-correct value is neither a splice nor a refusal
- removing a key takes its whole physical line, carries away a trailing comment
  that belongs to it, and leaves every byte outside that span identical
- a comment on the line *above* a removed key survives and stays attached to what
  follows it
- removing the only pair under a mapping respells it ``{}`` rather than leaving a
  key with no value, so the result still loads as a mapping
- removing an absent key is a no-op, and a flow mapping is refused rather than
  reformatted
- two edits in one document both land, applied last-first
- a YAML-aliased ``input`` node yields one node twice and is spliced ONCE, while
  two splices that share a span but disagree on its replacement are not merged
- the repo's authored fixture survives a set-then-remove round trip byte-exactly
- the module imports and splices with every database driver blocked

These unit tests assert on bytes rather than on a re-parse, because a serializer
that preserved comments and re-quoted every scalar would pass a semantic check
while destroying most of an authored document by volume. The callers are content
migrations that append a new head version of the artifact customers author, so a
splice that is merely *semantically* faithful is still a lost document.
"""

from __future__ import annotations

import subprocess
import sys
import textwrap
from pathlib import Path

import pytest
import yaml
from askalot_qml.core import qml_splice
from askalot_qml.core.qml_splice import (
    Splice,
    SpliceOutcome,
    apply_splices,
    iter_item_inputs,
    remove_pair,
    set_pair,
)

_FIXTURE = Path(__file__).resolve().parents[2] / "fixtures" / "roster_household_labour.qml"

SEMANTIC = "semantic"


def _edit_inputs(text: str, item_ids: set[str], edit) -> tuple[str, list[str], list[str]]:
    """Apply *edit* to the ``input`` mapping of each named item.

    Mirrors how a content migration drives this module: compose once, walk the
    tree, collect one outcome per item, then apply every splice in one pass.
    Returns ``(updated, touched, refused)``.
    """
    splices: list[Splice] = []
    touched: list[str] = []
    refused: list[str] = []
    for item_id, spec in iter_item_inputs(yaml.compose(text)):
        if item_id not in item_ids or not isinstance(spec, yaml.MappingNode):
            continue
        outcome = edit(text, spec)
        if outcome.refused:
            refused.append(item_id)
        elif outcome.splice is not None:
            splices.append(outcome.splice)
            touched.append(item_id)
    return apply_splices(text, splices), touched, refused


def _set_coding(text: str, item_ids: set[str]) -> tuple[str, list[str], list[str]]:
    return _edit_inputs(text, item_ids, lambda t, m: set_pair(t, m, "coding", SEMANTIC))


def _remove_coding(text: str, item_ids: set[str]) -> tuple[str, list[str], list[str]]:
    return _edit_inputs(text, item_ids, lambda t, m: remove_pair(t, m, "coding"))


def _required_splice(outcome: SpliceOutcome) -> Splice:
    """The splice an edit was expected to produce, asserted present.

    ``apply_splices`` takes ``Iterable[Splice]`` and does not tolerate ``None``,
    deliberately: ``outcome.splice is None`` means "nothing to do", which every
    caller must branch on rather than hand to the applier. A test expecting an
    edit narrows here, so a regression that quietly produced no splice fails on
    this assertion instead of on a confusing equality mismatch below it.
    """
    assert outcome.splice is not None, f"expected a splice, got {outcome!r}"
    return outcome.splice


def _input_mapping(text: str) -> yaml.MappingNode:
    """The value of the root-level ``input`` key — for single-mapping fixtures."""
    root = yaml.compose(text)
    spec = next(value for key, value in root.value if key.value == "input")
    assert isinstance(spec, yaml.MappingNode)
    return spec


#: An authored questionnaire in the shape authored ones actually take: comments
#: above keys and trailing on them, a multi-line block scalar, quoted strings in
#: two styles, and blank lines separating items. Every one of these is something
#: ``yaml.safe_dump`` re-emits in its own style rather than the author's.
_AUTHORED_QML = """\
# Household labour module
# Maintainer: methodology@askalot.io
qmlVersion: "2.3"

blocks:
  # Screening runs first; do not reorder.
  - id: screening
    items:
      - id: q_notes                 # free text, coded since 2026-03
        kind: Question
        title: 'Describe this person''s main duties'
        input:
          # A box, not a line — respondents write sentences here.
          control: Textarea
          rows: 4                   # tuned on the pilot
        codeInit: |
          set duties_seen = true
          if duties_seen then
            log("first duties response")
          end

      - id: q_age
        kind: Question
        title: "How old is this person?"
        input:
          control: Editbox
          min: 0
"""

#: The same document with the flag already declared — one key carrying a trailing
#: comment of its own, one not. Removal is asserted against this by byte
#: subtraction of the exact lines below.
_CODED_QML = """\
# Household labour module
# Maintainer: methodology@askalot.io
qmlVersion: "2.3"

blocks:
  # Screening runs first; do not reorder.
  - id: screening
    items:
      - id: q_notes                 # free text, coded since 2026-03
        kind: Question
        title: 'Describe this person''s main duties'
        input:
          # A box, not a line — respondents write sentences here.
          control: Textarea
          rows: 4                   # tuned on the pilot
          coding: semantic          # pilot
        codeInit: |
          set duties_seen = true
          if duties_seen then
            log("first duties response")
          end

      - id: q_age
        kind: Question
        title: "How old is this person?"
        input:
          control: Editbox
          min: 0
          coding: semantic
"""

_NOTES_CODING_LINE = "          coding: semantic          # pilot\n"
_AGE_CODING_LINE = "          coding: semantic\n"


@pytest.mark.unit
class TestSetPair:
    """#373: the parse is semantically lossless; the *document* was not.

    A content migration appends a new head ``document_versions`` row for every
    questionnaire it touches, on every tenant, against the artifact the product
    asks customers to author. A lossy serializer therefore makes the migration's
    own record of a questionnaire differ from what its author wrote, with no
    operator signal either way and recovery only by rewinding the version chain.

    Measured on ``roster_household_labour.qml`` before the fix: 35 comments
    became 5, 361 lines became 314, 11,822 bytes became 8,662.

    The byte-identity assertion is the load-bearing one. Counting comments alone
    would still pass a serializer that preserved comments and re-quoted every
    scalar, which is most of the damage by volume.
    """

    def test_only_the_inserted_line_differs(self):
        updated, touched, refused = _set_coding(_AUTHORED_QML, {"q_notes"})
        assert touched == ["q_notes"]
        assert refused == []
        added = [line for line in updated.splitlines() if line.strip() == "coding: semantic"]
        assert len(added) == 1, "expected exactly one inserted line"
        restored = "\n".join(
            line for line in updated.splitlines() if line.strip() != "coding: semantic"
        )
        assert restored + "\n" == _AUTHORED_QML, (
            "the document changed outside the inserted line — a serializer is "
            "round-tripping it again (#373)"
        )

    def test_comments_and_block_scalars_survive(self):
        """Named separately from byte-identity so a failure says which half broke."""
        updated, _, _ = _set_coding(_AUTHORED_QML, {"q_notes"})
        assert updated.count("#") == _AUTHORED_QML.count("#")
        assert "# tuned on the pilot" in updated
        assert "title: 'Describe this person''s main duties'" in updated
        # The block scalar keeps real newlines rather than becoming a folded
        # single-quoted scalar with blank lines standing in for them.
        assert "codeInit: |\n" in updated
        assert "          if duties_seen then\n" in updated

    def test_the_new_key_lands_inside_the_right_input_block(self):
        updated, _, _ = _set_coding(_AUTHORED_QML, {"q_notes"})
        doc = yaml.safe_load(updated)
        items = {i["id"]: i for i in doc["blocks"][0]["items"]}
        assert items["q_notes"]["input"]["coding"] == SEMANTIC
        assert "coding" not in items["q_age"]["input"]
        assert items["q_notes"]["input"]["rows"] == 4

    def test_a_trailing_comment_keeps_its_subject(self):
        """The insert anchors to the *end of the last pair's line*, not to the
        end of its value — otherwise ``rows: 4  # tuned on the pilot`` becomes
        ``rows: 4`` with the comment orphaned onto the new key."""
        updated, _, _ = _set_coding(_AUTHORED_QML, {"q_notes"})
        assert "rows: 4                   # tuned on the pilot" in updated

    def test_an_existing_value_is_retargeted_not_requoted(self):
        """A stale ``coding: 'none'`` is replaced value-and-quotes, so the result
        is ``coding: semantic`` rather than ``semantic`` nested in old quotes."""
        qml = (
            "blocks:\n  - id: b1\n    items:\n      - id: q_notes\n"
            "        input:\n          control: Textarea\n          coding: 'none'\n"
        )
        updated, touched, refused = _set_coding(qml, {"q_notes"})
        assert touched == ["q_notes"]
        assert refused == []
        assert "coding: semantic\n" in updated
        assert "'" not in updated

    def test_an_already_correct_value_is_neither_a_splice_nor_a_refusal(self):
        """The quiet case has to stay distinguishable from the loud one: a caller
        that collapsed them would report an un-editable document as done."""
        qml = "input:\n  control: Textarea\n  coding: semantic\n"
        outcome = set_pair(qml, _input_mapping(qml), "coding", SEMANTIC)
        assert outcome.splice is None
        assert outcome.refused is False

    def test_a_flow_mapping_is_refused_rather_than_reformatted(self):
        """Converting ``input: {control: Textarea}`` to block style is a
        whole-node reformat — the class of change this module exists to not
        make. It is refused out loud rather than silently skipped."""
        qml = (
            "blocks:\n  - id: b1\n    items:\n      - id: q_flow\n"
            "        input: {control: Textarea}\n"
        )
        updated, touched, refused = _set_coding(qml, {"q_flow"})
        assert touched == []
        assert refused == ["q_flow"]
        assert updated == qml

    def test_two_items_in_one_document_both_land_correctly(self):
        """Splices are applied last-first so an earlier insert cannot invalidate
        a later offset. With a single target this test would pass either way."""
        updated, touched, _ = _set_coding(_AUTHORED_QML, {"q_notes", "q_age"})
        assert sorted(touched) == ["q_age", "q_notes"]
        doc = yaml.safe_load(updated)
        items = {i["id"]: i for i in doc["blocks"][0]["items"]}
        assert items["q_notes"]["input"]["coding"] == SEMANTIC
        assert items["q_age"]["input"]["coding"] == SEMANTIC
        assert items["q_notes"]["input"]["rows"] == 4
        assert items["q_age"]["input"]["min"] == 0
        assert updated.count("#") == _AUTHORED_QML.count("#")

    def test_the_repo_fixture_survives_marking(self):
        """The exact document #373 measured. A synthetic fixture proves the
        module self-consistent; this proves it against a real authored one."""
        source = _FIXTURE.read_text()
        updated, touched, _ = _set_coding(source, {"q_member_name"})
        assert touched == ["q_member_name"]
        assert updated.count("#") == source.count("#") == 35
        restored = "\n".join(
            line for line in updated.splitlines() if line.strip() != "coding: semantic"
        )
        assert restored + "\n" == source


@pytest.mark.unit
class TestRemovePair:
    """Removal is not the inverse of insertion.

    An insert adds a line and touches nothing else. A removal has to decide how
    much of a *physical* line belongs to the key it is deleting — a trailing
    comment does, a comment on the line above does not — and what a mapping is
    when its last pair leaves, which block YAML has no spelling for.

    The consumer is a migration that recomposes old against new and refuses to
    write unless the only delta is the removed key, so an over-wide span is the
    failure that guard exists to catch. These tests assert the span directly,
    by byte subtraction, rather than through a re-parse that could not see it.
    """

    def test_only_the_removed_line_differs(self):
        updated, touched, refused = _remove_coding(_CODED_QML, {"q_notes"})
        assert touched == ["q_notes"]
        assert refused == []
        assert updated == _CODED_QML.replace(_NOTES_CODING_LINE, "")

    def test_a_trailing_comment_leaves_with_its_key(self):
        """``coding: semantic  # pilot`` — the comment annotates the key being
        removed, so leaving it behind would orphan it onto the block scalar that
        follows, where it would read as documentation of something else."""
        updated, _, _ = _remove_coding(_CODED_QML, {"q_notes"})
        assert "# pilot" not in updated
        assert updated.count("#") == _CODED_QML.count("#") - 1
        # Every other comment in the document is untouched.
        assert "# free text, coded since 2026-03" in updated
        assert "# A box, not a line" in updated
        assert "rows: 4                   # tuned on the pilot" in updated

    def test_a_comment_above_the_removed_key_survives(self):
        """Deliberate: nothing in the node tree says whether that comment
        annotates the key, the mapping, or the block. It stays, attached to
        whatever now follows it."""
        qml = (
            "input:\n"
            "  control: Textarea\n"
            "  # Coding was switched on for the pilot.\n"
            "  coding: semantic\n"
            "  rows: 4\n"
        )
        outcome = remove_pair(qml, _input_mapping(qml), "coding")
        assert apply_splices(qml, [_required_splice(outcome)]) == (
            "input:\n  control: Textarea\n  # Coding was switched on for the pilot.\n  rows: 4\n"
        )

    def test_removing_the_only_pair_leaves_a_mapping_the_loader_still_parses(self):
        """An emptied block mapping has no block spelling. Leaving ``input:``
        with no value would load as ``None`` — a different document, and one a
        caller's "the only delta is the removed key" check would reject."""
        qml = "items:\n  - id: q_notes\n    input:\n      coding: semantic\n"
        updated, touched, _ = _remove_coding(qml, {"q_notes"})
        assert touched == ["q_notes"]
        assert updated == "items:\n  - id: q_notes\n    input:\n      {}\n"
        assert yaml.safe_load(updated) == {"items": [{"id": "q_notes", "input": {}}]}

    def test_removing_an_absent_key_is_a_no_op_not_an_error(self):
        qml = "input:\n  control: Textarea\n  rows: 4\n"
        outcome = remove_pair(qml, _input_mapping(qml), "coding")
        assert outcome.splice is None
        assert outcome.refused is False
        assert apply_splices(qml, []) == qml

    def test_two_removals_in_one_document_both_land(self):
        """Applied last-first, so the first deletion cannot shift the second
        span. With a single target this test would pass either way."""
        updated, touched, _ = _remove_coding(_CODED_QML, {"q_notes", "q_age"})
        assert sorted(touched) == ["q_age", "q_notes"]
        assert updated == _CODED_QML.replace(_NOTES_CODING_LINE, "").replace(_AGE_CODING_LINE, "")

    def test_a_multi_line_value_is_removed_whole(self):
        """A block scalar's ``end_mark`` lands at column 0 of the *next* line;
        uncorrected, the span would swallow the key that follows."""
        qml = (
            "input:\n"
            "  control: Textarea\n"
            "  hint: |\n"
            "    Write freely.\n"
            "    Sentences are fine.\n"
            "  rows: 4\n"
        )
        outcome = remove_pair(qml, _input_mapping(qml), "hint")
        assert apply_splices(qml, [_required_splice(outcome)]) == (
            "input:\n  control: Textarea\n  rows: 4\n"
        )

    def test_a_flow_mapping_is_refused_rather_than_reformatted(self):
        qml = "input: {control: Textarea, coding: semantic}\n"
        outcome = remove_pair(qml, _input_mapping(qml), "coding")
        assert outcome.splice is None
        assert outcome.refused is True

    def test_a_key_sharing_its_line_with_other_content_is_refused(self):
        """``- coding: semantic`` is the first pair of a sequence item, so its
        physical line carries the ``- `` that makes the item an item. Deleting
        the line would orphan every remaining pair out of the sequence, so the
        removal is refused instead."""
        qml = "items:\n  - coding: semantic\n    control: Textarea\n"
        mapping = yaml.compose(qml).value[0][1].value[0]
        assert isinstance(mapping, yaml.MappingNode)
        outcome = remove_pair(qml, mapping, "coding")
        assert outcome.splice is None
        assert outcome.refused is True


@pytest.mark.unit
class TestAnAliasedNodeIsSplicedOnce:
    """A YAML alias makes one node reachable twice; it must still be one edit.

    ``yaml.compose`` resolves ``*open_text`` to the *same node object* the
    ``&open_text`` anchor produced, so a pre-order walk yields it once per
    reference — with a single set of marks, because there is a single node. The
    caller collects one splice per yielded node and gets duplicates over one
    span.

    Applying that span twice removes it twice. The damage is not local: the
    migration's byte-diff guard sees more removed than the one ``coding`` line
    it sanctions and aborts the WHOLE batch, so one anchored questionnaire makes
    every document unmigratable and holds the release gate red.
    """

    _ALIASED = textwrap.dedent(
        """\
        blocks:
          - id: intro
            items:
              - id: q_first
                input: &open_text
                  control: Textarea
                  coding: semantic
              - id: q_second
                input: *open_text
        """
    )

    def test_the_walk_really_does_yield_one_node_twice(self):
        """Pinned first: without this the test below could pass because the
        fixture stopped exercising aliasing, not because the fix works."""
        nodes = [spec for _, spec in iter_item_inputs(yaml.compose(self._ALIASED))]
        assert len(nodes) == 2
        assert nodes[0] is nodes[1]

    def test_duplicate_splices_over_one_span_collapse_to_one_edit(self):
        root = yaml.compose(self._ALIASED)
        splices = []
        for _, spec in iter_item_inputs(root):
            assert isinstance(spec, yaml.MappingNode)
            outcome = remove_pair(self._ALIASED, spec, "coding")
            assert outcome.splice is not None
            splices.append(outcome.splice)

        assert splices[0] == splices[1], "the fixture no longer produces a duplicate span"

        result = apply_splices(self._ALIASED, splices)

        # Exactly one line gone, and it is the coding line — not the control
        # line the second application would have taken with it.
        assert "coding: semantic" not in result
        assert result.splitlines() == [
            line for line in self._ALIASED.splitlines() if "coding: semantic" not in line
        ]

    def test_a_disagreeing_pair_over_one_span_is_not_collapsed(self):
        """The dedup is exact-match only. Two splices sharing a span but not a
        replacement are a real disagreement about what the span should say;
        silently keeping one would be the collapse hiding a caller bug."""
        text = "a: 1\n"
        both = apply_splices(text, [Splice(0, 4, "b: 2"), Splice(0, 4, "c: 3")])
        assert both != text
        assert both.count("\n") == 1


@pytest.mark.unit
class TestSetThenRemoveRoundTrip:
    def test_the_repo_fixture_survives_a_round_trip_byte_identically(self):
        """The property U11's migration depends on, stated end to end: a document
        this module edited and then un-edited is the document it started from,
        byte for byte — not merely one that parses the same."""
        source = _FIXTURE.read_text()
        marked, touched, _ = _set_coding(source, {"q_member_name"})
        assert touched == ["q_member_name"]
        assert marked != source
        restored, removed, refused = _remove_coding(marked, {"q_member_name"})
        assert removed == ["q_member_name"]
        assert refused == []
        assert restored == source


@pytest.mark.unit
class TestTheModuleIsDatabaseFree:
    """R20: the splicer's new home must not need a driver to be usable.

    The callers are content migrations that read QML out of Postgres — but the
    splicing itself is text in, text out, and pinning that keeps the module
    reusable outside a migration and testable without a database.
    """

    def test_the_module_imports_and_splices_with_every_driver_blocked(self):
        """A subprocess, because the guard has to act at import time and this
        test session has already imported the module. Loaded by path so the
        assertion is about *this file's* import graph, not the whole
        ``askalot_qml.core`` package's.
        """
        probe = textwrap.dedent(
            f"""
            import importlib.abc, importlib.util, sys

            BLOCKED = {{"psycopg", "psycopg2", "psycopg_pool", "asyncpg",
                       "sqlalchemy", "alembic", "askalot_common"}}

            class Blocker(importlib.abc.MetaPathFinder):
                def find_spec(self, fullname, path=None, target=None):
                    if fullname.split(".")[0] in BLOCKED:
                        raise ImportError("not installed: " + fullname)
                    return None

            sys.meta_path.insert(0, Blocker())

            spec = importlib.util.spec_from_file_location(
                "qml_splice_probe", {str(qml_splice.__file__)!r}
            )
            module = importlib.util.module_from_spec(spec)
            # Registered before exec: @dataclass resolves its own module out of
            # sys.modules while the class body is being processed.
            sys.modules[spec.name] = module
            spec.loader.exec_module(module)

            import yaml

            text = "input:\\n  control: Textarea\\n  coding: semantic\\n"
            mapping = yaml.compose(text).value[0][1]
            outcome = module.remove_pair(text, mapping, "coding")
            assert module.apply_splices(text, [outcome.splice]) == (
                "input:\\n  control: Textarea\\n"
            )
            """
        )
        result = subprocess.run([sys.executable, "-c", probe], capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
