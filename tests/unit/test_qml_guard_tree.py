"""
The guard tree: a questionnaire's branches, nested by Z3-proven implication (#1970).

Tests QMLGuardTree and its place in the diagram IR:
- items sharing one effective guard form one node, whether the guard sits on
  the block or is repeated on each item; unguarded items form the trunk
- a screener's two paths (A and not-A) are exclusive siblings under the trunk
- a follow-up guarded by A and its own condition nests under A
- a guard that overlaps a branch without implying it is an overlapping sibling
- with no budget left every check is undecided, and the tree says so on the
  node (undecided_parents, undecided_with) instead of nesting by default;
  past the budget no check is built or asked, the budget covers grouping, and
  a pair answered inside it keeps its answer (#2113)
- a Roster's iterateOver is repetition, not a guard; a cyclic questionnaire
  still places every item exactly once
- a solver answer across two lowerings proves "parallel" or "not nested"
  only when it holds for every symbol a lowering mints for itself, else the
  relation is undecided; a None guard after its item reads that item's skip
  and blank choices (#2046), one before it or on a code-written item does not; one guard text reading two versions of a variable is
  two nodes
- an exclusive pair is never undecided nesting (#2045) when the nesting check
  does not answer, unless a guard was not shown satisfiable
- an undecided never / always check is an "undecided" status, counted; a guard
  that never holds takes no sibling marks
- the loop breaker moves only a guard on the loop to the trunk; lowering a
  guard records its coverage gaps at the indices the classifier uses
- the tree is built on demand only (get_guard_tree), never into the
  validation graph, and guard_tree_answer serves it for posted content

These unit tests run the real loader, StaticBuilder and solver over committed
fixtures and inline questionnaires, so a nesting or exclusivity mark is the one
Z3 proves, not a mock's.
"""

import time
from pathlib import Path

from askalot_common.questionnaire_templates import get_questionnaire_template_qml
from askalot_qml.api import guard_tree_answer
from askalot_qml.core import qml_guard_tree
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_guard_tree import QMLGuardTree, break_parent_loops
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState
from z3 import is_not, unknown

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def _state(fixture: str) -> QMLState:
    return QMLState(QMLLoader(qml_dir=FIXTURES_DIR).load_from_file(fixture))


def _tree(fixture: str, **bounds) -> dict:
    state = _state(fixture)
    engine = QMLEngine(state)
    return QMLGuardTree(
        engine.static_builder, state, list(engine.topology.topological_order), **bounds
    ).build()


def _inline(items: list[str], code_init: str | None = None) -> QMLState:
    """A one-block questionnaire of the given items (``_radio``)."""
    head = 'qmlVersion: "2.0"\nquestionnaire:\n  title: "Inline"\n'
    if code_init:
        head += f'  codeInit: "{code_init}"\n'
    head += "  blocks:\n    - id: b\n      kind: Group\n      title: B\n      items:\n"
    return QMLState(QMLLoader().load_from_string(head + "".join(items)))


def _radio(item_id: str, precondition: str | None = None, code: str | None = None) -> str:
    text = (
        f"        - id: {item_id}\n          kind: Question\n          title: \"{item_id}?\"\n"
        "          input:\n            control: Radio\n            labels:\n"
        '              1: "One"\n              2: "Two"\n'
    )
    if precondition:
        text += f'          precondition:\n            - predicate: "{precondition}"\n'
    if code:
        text += f'          codeBlock: "{code}"\n'
    return text


def _tree_of(state: QMLState, **bounds) -> dict:
    engine = QMLEngine(state)
    return QMLGuardTree(
        engine.static_builder, state, list(engine.topology.topological_order), **bounds
    ).build()


def _node_of(tree: dict, item_id: str) -> dict:
    return next(n for n in tree["nodes"] if item_id in n["items"])


class TestBranches:
    def test_shared_guards_group_and_unguarded_items_form_the_trunk(self):
        tree = _tree("guard_tree_branches.qml")
        assert tree["trunk"] == ["q_screen", "q_contact"]
        assert _node_of(tree, "q_brand")["items"] == ["q_brand", "q_age"]
        assert _node_of(tree, "q_transport")["items"] == ["q_transport", "q_plan"]
        assert len(tree["nodes"]) == 4

    def test_screener_paths_are_exclusive_siblings_under_the_trunk(self):
        tree = _tree("guard_tree_branches.qml")
        yes, no = _node_of(tree, "q_brand"), _node_of(tree, "q_transport")
        assert yes["parent"] is None and no["parent"] is None
        assert no["id"] in yes["exclusive_with"]
        assert yes["id"] in no["exclusive_with"]

    def test_follow_up_nests_inside_its_branch(self):
        tree = _tree("guard_tree_branches.qml")
        yes, follow = _node_of(tree, "q_brand"), _node_of(tree, "q_import_reason")
        assert follow["parent"] == yes["id"]
        assert follow["depth"] == 2
        assert follow["predicates"] == ["q_screen.outcome == 1", "q_brand.outcome == 2"]
        assert follow["undecided_parents"] == []

    def test_an_overlapping_guard_is_a_parallel_run(self):
        tree = _tree("guard_tree_branches.qml")
        email, yes, no = (_node_of(tree, i) for i in ("q_email", "q_brand", "q_transport"))
        assert email["parent"] is None
        assert {yes["id"], no["id"]} <= set(email["overlaps_with"])
        assert email["exclusive_with"] == [] and email["undecided_with"] == []

    def test_undecided_checks_are_marked_not_defaulted(self):
        tree = _tree("guard_tree_branches.qml", budget_ms=0)
        yes, follow = _node_of(tree, "q_brand"), _node_of(tree, "q_import_reason")
        assert tree["budget_exhausted"] is True
        assert follow["parent"] is None
        assert yes["id"] in follow["undecided_parents"]
        assert follow["id"] in yes["undecided_with"]
        assert yes["exclusive_with"] == [] and yes["overlaps_with"] == []

    def test_an_undecided_never_or_always_check_is_a_status_of_its_own(self):
        tree = _tree("guard_tree_branches.qml", budget_ms=0)
        assert {n["status"] for n in tree["nodes"]} == {"undecided"}
        # Every status check, nesting check and sibling check went unanswered.
        assert tree["checks"]["undecided"] >= len(tree["nodes"])

    def test_a_false_guard_with_no_budget_is_undecided_not_conditional(self):
        tree = _tree_of(_inline([_radio("q"), _radio("x", "False")]), budget_ms=0)
        assert _node_of(tree, "x")["status"] == "undecided"
        assert tree["checks"]["undecided"] == 1

    def test_either_status_check_left_unknown_is_undecided(self):
        # The solver answers unknown for the never check (the guard alone) or
        # for the always check (its negation), and settles everything else.
        class Unsettled(QMLGuardTree):
            def __init__(self, *args, negated: bool, **kwargs):
                super().__init__(*args, **kwargs)
                self.negated = negated

            def _solve(self, *assertions):
                if len(assertions) == 1 and is_not(assertions[0]) == self.negated:
                    self._checks_run += 1
                    return unknown
                return super()._solve(*assertions)

        for negated in (False, True):
            state = _state("guard_tree_branches.qml")
            engine = QMLEngine(state)
            tree = Unsettled(
                engine.static_builder, state, list(engine.topology.topological_order), negated=negated
            ).build()
            assert {n["status"] for n in tree["nodes"]} == {"undecided"}, negated
            assert tree["checks"]["undecided"] >= len(tree["nodes"])


class _CountingChecks(QMLGuardTree):
    """Counts every check whose terms were built and handed to the solver, and can
    make grouping the guards take ``group_delay`` seconds."""

    def __init__(self, *args, group_delay: float = 0.0, **kwargs):
        super().__init__(*args, **kwargs)
        self.group_delay = group_delay
        self.asked = 0

    def _group(self):
        grouped = super()._group()
        time.sleep(self.group_delay)
        return grouped

    def _solve(self, *assertions):
        self.asked += 1
        return super()._solve(*assertions)


def _many_guards(count: int) -> QMLState:
    """``count`` screeners, each gating one follow-up on its own answer."""
    items = []
    for i in range(count):
        items += [_radio(f"s{i}"), _radio(f"f{i}", f"s{i}.outcome == 1")]
    return _inline(items)


class TestTheBudgetBoundsTheBuild:
    """#2113: past the budget no check is built or asked, every remaining
    relation is still counted undecided, and the budget's clock covers
    grouping the guards."""

    def _build(self, state: QMLState, **kwargs) -> tuple[dict, _CountingChecks]:
        engine = QMLEngine(state)
        tree = _CountingChecks(
            engine.static_builder, state, list(engine.topology.topological_order), **kwargs
        )
        return tree.build(), tree

    def test_no_check_is_asked_once_the_budget_is_spent(self, monkeypatch):
        # Counted where a check's terms are built, not where they are solved:
        # an eager build past the budget costs more than the budget (#2113).
        built_terms = []
        real_not, real_forall = qml_guard_tree.Not, qml_guard_tree.ForAll
        monkeypatch.setattr(qml_guard_tree, "Not", lambda *a: built_terms.append("Not") or real_not(*a))
        monkeypatch.setattr(
            qml_guard_tree, "ForAll", lambda *a: built_terms.append("ForAll") or real_forall(*a)
        )
        built, tree = self._build(_many_guards(30), budget_ms=0)
        assert built_terms == []
        assert tree.asked == 0
        assert built["budget_exhausted"] is True
        assert built["checks"]["run"] == 0
        nodes = len(built["nodes"])
        # Every status, every ordered nesting pair and every trunk sibling pair.
        assert built["checks"]["undecided"] == nodes + nodes * (nodes - 1) + nodes * (nodes - 1) // 2
        assert {n["status"] for n in built["nodes"]} == {"undecided"}

    def test_grouping_the_guards_spends_the_same_budget(self):
        built, tree = self._build(_many_guards(3), budget_ms=50, group_delay=0.1)
        assert built["budget_exhausted"] is True
        assert tree.asked == 0

    def test_a_pair_answered_inside_the_budget_keeps_its_answer_past_it(self):
        state = _state("guard_tree_branches.qml")
        engine = QMLEngine(state)
        tree = QMLGuardTree(engine.static_builder, state, list(engine.topology.topological_order))
        built = tree.build()
        yes, no = (_node_of(built, i)["id"] for i in ("q_brand", "q_transport"))
        _, guards = tree._group()
        by_id = {g["id"]: g for g in guards}
        tree._deadline = 0.0
        assert tree._exclusive(by_id[yes], by_id[no]) == "yes"
        assert tree._exclusive(by_id[yes], by_id[_node_of(built, "q_email")["id"]]) == "no"


class _ImplicationUnknown(QMLGuardTree):
    """The solver answers ``unknown`` for every nesting check (``a ∧ ¬b``),
    and, with *status_unknown*, for every status check too; everything else
    is solved."""

    def __init__(self, *args, status_unknown: bool = False, **kwargs):
        super().__init__(*args, **kwargs)
        self.status_unknown = status_unknown

    def _solve(self, *assertions):
        nesting = len(assertions) == 2 and is_not(assertions[1])
        status = len(assertions) == 1 and self.status_unknown
        if nesting or status:
            self._checks_run += 1
            return unknown
        return super()._solve(*assertions)


class TestExclusivePairsAreNotUndecidedNesting:
    """#2045: two guards that can never both hold do not nest, even when the
    nesting check itself does not answer: ``unsat(a ∧ b)`` with ``a`` exact
    and satisfiable proves ``a ⇏ b``."""

    @staticmethod
    def _build(**kwargs) -> dict:
        state = _inline([_radio("q"), _radio("a", "q.outcome == 1"), _radio("b", "q.outcome == 2")])
        engine = QMLEngine(state)
        return _ImplicationUnknown(
            engine.static_builder, state, list(engine.topology.topological_order), **kwargs
        ).build()

    def test_an_exclusive_pair_lists_no_undecided_parent(self):
        tree = self._build()
        a, b = _node_of(tree, "a"), _node_of(tree, "b")
        assert a["undecided_parents"] == [] and b["undecided_parents"] == []
        assert b["id"] in a["exclusive_with"]

    def test_a_guard_not_shown_satisfiable_keeps_the_pair_undecided(self):
        tree = self._build(status_unknown=True)
        a, b = _node_of(tree, "a"), _node_of(tree, "b")
        assert b["id"] in a["undecided_parents"] and a["id"] in b["undecided_parents"]


class TestSoundAcrossLowerings:
    def test_symbols_minted_per_lowering_prove_no_overlap_or_non_nesting(self):
        # r's codeBlock may answer q between the two guards, so each keeps its
        # own answered@q#n: q answered at one guard and not at the other is a
        # model of two unrelated Bools, not a proof.
        tree = _tree_of(
            _inline(
                [
                    _radio("q"),
                    _radio("r", code="q.outcome = 1"),
                    _radio("a", "q.outcome is not None"),
                    _radio("f", "q.outcome is not None and r.outcome == 1"),
                ]
            )
        )
        a, f = _node_of(tree, "a"), _node_of(tree, "f")
        assert a["overlaps_with"] == [] and f["overlaps_with"] == []
        assert a["id"] in f["undecided_with"]
        assert a["id"] in f["undecided_parents"]

    def test_a_none_guard_after_its_item_reads_the_world(self):
        # #2046: past q, q's None-ness is its blank choice, the same at every
        # later guard, so the guards nest and overlap as their answers say.
        tree = _tree_of(
            _inline(
                [
                    _radio("q"),
                    _radio("r"),
                    _radio("a", "q.outcome is not None"),
                    _radio("f", "q.outcome is not None and r.outcome == 1"),
                    _radio("c", "r.outcome == 2"),
                    _radio("n", "q.outcome is None"),
                ]
            )
        )
        a, f, c, n = (_node_of(tree, i) for i in ("a", "f", "c", "n"))
        assert f["parent"] == a["id"] and f["undecided_parents"] == []
        assert c["id"] in a["overlaps_with"]
        assert n["id"] in a["exclusive_with"]
        assert tree["checks"]["undecided"] == 0

    def test_a_gated_items_free_skip_proves_no_overlap(self):
        # x is asked exactly when s == 1 and refuses a blank, so "x is None"
        # and "s == 1" never both hold; the skip choice is free of x's gate,
        # so the overlap it would show is no walk (code review on #2149).
        refusing_blank = _radio("x", "s.outcome == 1") + (
            '          postcondition:\n            - predicate: "x.outcome is not None"\n'
        )
        tree = _tree_of(
            _inline([_radio("s"), refusing_blank, _radio("a", "x.outcome is None"), _radio("b", "s.outcome == 1")])
        )
        a, b = _node_of(tree, "a"), _node_of(tree, "b")
        assert b["id"] not in a["overlaps_with"]

    def test_a_gated_items_choices_still_prove_nesting(self):
        # Refutations stay sound over the wider choices: past the gated x,
        # "x answered and r == 1" implies "x answered".
        tree = _tree_of(
            _inline(
                [
                    _radio("s"),
                    _radio("x", "s.outcome == 1"),
                    _radio("r"),
                    _radio("a", "x.outcome is not None"),
                    _radio("f", "x.outcome is not None and r.outcome == 1"),
                ]
            )
        )
        assert _node_of(tree, "f")["parent"] == _node_of(tree, "a")["id"]

    def test_a_symbol_minted_for_another_items_acceptance_keeps_its_moment(self):
        # Codex on #2149: y's blank acceptance reads x before x is asked (the
        # cycle puts y first), and b's guard conjoins it. Tied at b's position
        # it would prove b under a, which a walk answering y blank, then x,
        # falsifies.
        y = (
            "        - id: y\n          kind: Question\n          title: \"y?\"\n"
            "          input:\n            control: Radio\n            labels:\n"
            '              1: "One"\n'
            '          postcondition:\n            - predicate: "x.outcome is None"\n'
            '          codeBlock: "y.outcome = y.outcome"\n'
        )
        state = _inline([y, _radio("x", "y.outcome is None"), _radio("a", "y.outcome == 1"), _radio("b", "x.outcome is not None")])
        engine = QMLEngine(state)
        order = list(engine.topology.topological_order)
        assert order.index("y") < order.index("x")
        tree = _tree_of(state)
        a, b = _node_of(tree, "a"), _node_of(tree, "b")
        assert b["parent"] != a["id"]
        assert a["id"] not in b["also_under"]

    def test_a_skip_and_a_blank_each_leave_the_item_none(self):
        # g can only be skipped (its postcondition refuses a blank), b can only
        # be left blank (it has no gate): a later "is None" guard on either
        # holds in some walk, so neither is "never".
        refusing_blank = _radio("g", "s.outcome == 1") + (
            '          postcondition:\n            - predicate: "g.outcome is not None"\n'
        )
        tree = _tree_of(
            _inline([_radio("s"), refusing_blank, _radio("b"), _radio("x", "g.outcome is None"), _radio("y", "b.outcome is None")])
        )
        assert _node_of(tree, "x")["status"] == "conditional"
        assert _node_of(tree, "y")["status"] == "conditional"

    def test_a_none_guard_read_before_its_item_keeps_its_own_symbol(self):
        # A guard reading q follows q in the walk, except across a cycle: b and
        # q read each other, the walk drops q -> b and asks b first, where q
        # reads None whatever q's choices, so b and a (after q) are not proved
        # exclusive.
        state = _inline(
            [
                _radio("s"),
                _radio("b", "q.outcome is None and s.outcome == 1"),
                _radio("q", "b.outcome == 1"),
                _radio("a", "q.outcome is not None"),
            ]
        )
        engine = QMLEngine(state)
        order = list(engine.topology.topological_order)
        assert order.index("b") < order.index("q")
        tree = _tree_of(state)
        a, b = _node_of(tree, "a"), _node_of(tree, "b")
        assert a["id"] not in b["exclusive_with"]
        assert a["id"] in b["undecided_with"]

    def test_the_market_trends_template_has_no_undecided_branch(self):
        state = QMLState(
            QMLLoader().load_from_string(get_questionnaire_template_qml("market-trends-and-challenges"))
        )
        tree = _tree_of(state)
        assert tree["checks"]["undecided"] == 0
        role = next(n for n in tree["nodes"] if n["predicates"] == ["q_role.outcome == 5"])
        challenges = next(n for n in tree["nodes"] if any("q_main_challenges" in p for p in n["predicates"]))
        assert role["id"] in challenges["overlaps_with"] + challenges["exclusive_with"]

    def test_answers_alone_still_prove_parallel_runs(self):
        tree = _tree_of(_inline([_radio("q"), _radio("r"), _radio("a", "q.outcome == 1"), _radio("c", "r.outcome == 1")]))
        assert _node_of(tree, "c")["id"] in _node_of(tree, "a")["overlaps_with"]

    def test_a_frozen_variable_keeps_its_value_under_the_quantifier(self):
        tree = _tree_of(
            _inline([_radio("q"), _radio("a", "x == 1"), _radio("c", "q.outcome == 1")], code_init="x = 1")
        )
        assert _node_of(tree, "a")["status"] == "always"
        assert _node_of(tree, "c")["id"] in _node_of(tree, "a")["overlaps_with"]

    def test_one_text_reading_two_versions_is_two_nodes(self):
        # a reads x before its own codeBlock rewrites it; b reads the new value.
        tree = _tree_of(
            _inline(
                [_radio("a", "x == 1", code="x = a.outcome"), _radio("b", "x == 1"), _radio("c", "x == 2")],
                code_init="x = 1",
            )
        )
        a, b, c = (_node_of(tree, i) for i in ("a", "b", "c"))
        assert a["id"] != b["id"]
        assert c["id"] in b["exclusive_with"]
        assert c["id"] not in a["overlaps_with"] + a["exclusive_with"]

    def test_a_block_counter_read_at_later_versions_is_not_the_first_items_guard(self):
        # #1891's founding article: six concept questions all read
        # `negative_count < 3`, each at the counter's version at its submission.
        tree = _tree("b390/1891-block-counter.qml")
        concepts = [_node_of(tree, f"q_concept_{i}") for i in range(1, 7)]
        assert len({n["id"] for n in concepts}) == 6
        assert concepts[0]["status"] == "always"
        assert [n["status"] for n in concepts[3:]] == ["conditional"] * 3

    def test_a_guard_that_never_holds_takes_no_sibling_marks(self):
        tree = _tree_of(
            _inline([_radio("q"), _radio("a", "q.outcome == 1"), _radio("c", "q.outcome == 2"), _radio("n", "q.outcome == 3")])
        )
        never = _node_of(tree, "n")
        assert never["status"] == "never"
        assert never["exclusive_with"] == never["overlaps_with"] == never["undecided_with"] == []
        assert all(never["id"] not in n["exclusive_with"] for n in tree["nodes"])

    def test_lowering_records_gaps_where_the_classifier_does(self):
        def state():
            return QMLState(
                QMLLoader().load_from_string(
                    'qmlVersion: "2.0"\nquestionnaire:\n  title: "Gaps"\n  blocks:\n'
                    "    - id: first\n      kind: Group\n      title: First\n      items:\n"
                    + _radio("r")
                    + _radio("g", "r.outcome == 2")
                    + "    - id: second\n      kind: Group\n      title: Second\n"
                    '      precondition:\n        - predicate: "r.outcome == 1"\n      items:\n'
                    + _radio("z", "abs(g.outcome) > 0")
                )
            )

        tree_state = state()
        engine = QMLEngine(tree_state)
        QMLGuardTree(engine.static_builder, tree_state, list(engine.topology.topological_order)).build()
        processor = ValidationProcessor(state())
        processor.get_item_classifications()

        tree_gaps = engine.static_builder.coverage_gaps.get("z")
        assert tree_gaps and [g["condition_idx"] for g in tree_gaps] == [1]
        assert tree_gaps == processor.engine.static_builder.coverage_gaps["z"]


class TestLoopBreaker:
    def test_only_a_guard_on_the_loop_moves_to_the_trunk(self):
        # a hangs on b; b and c point at each other.
        parent = {"a": "b", "b": "c", "c": "b"}
        also_under = {"a": ["x"], "b": ["y"], "c": []}
        break_parent_loops(parent, also_under)
        assert parent == {"a": "b", "b": None, "c": "b"}
        assert also_under == {"a": ["x"], "b": [], "c": []}


class TestOtherShapes:
    def test_roster_iterate_over_is_not_a_guard(self):
        tree = _tree("roster_numeric.qml")
        assert all("family_mask" not in " ".join(n["predicates"]) for n in tree["nodes"])

    def test_cycles_place_every_item_once(self):
        state = _state("defect_cycle.qml")
        tree = _tree("defect_cycle.qml")
        placed = tree["trunk"] + [i for n in tree["nodes"] for i in n["items"]]
        assert sorted(placed) == sorted(i["id"] for i in state.get_items())


class TestOnDemand:
    def test_the_validation_graph_never_carries_the_tree(self):
        processor = ValidationProcessor(_state("guard_tree_branches.qml"))
        assert "guard_tree" not in processor.generate_validation_graph()["metadata"]
        assert processor._guard_tree is None
        assert processor.get_guard_tree()["trunk"] == ["q_screen", "q_contact"]

    def test_the_answer_for_posted_content(self):
        content = (FIXTURES_DIR / "guard_tree_branches.qml").read_text()
        body, status = guard_tree_answer(content, "branches.qml", content_origin="editor")
        assert status == 200
        assert body["qml_name"] == "branches.qml" and body["content_origin"] == "editor"
        assert body["guard_tree"]["trunk"] == ["q_screen", "q_contact"]

    def test_content_that_does_not_load_answers_the_validation_fault(self):
        body, status = guard_tree_answer("questionnaire: [", "broken.qml", content_origin="editor")
        assert status == 400 and "parse_error" in body
