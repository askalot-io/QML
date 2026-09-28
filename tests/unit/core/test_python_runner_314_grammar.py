"""
The code sandbox refuses 3.14's added grammar for the same reasons 3.12 did.

`_check_ast_safety` reports no issue for a node type it does not recognise, so a
larger grammar silently widens what reaches the restricted execution
environment. Python 3.14 adds exactly two AST node types — `ast.TemplateStr` and
`ast.Interpolation`, PEP 750 t-strings — and relaxes one rule, PEP 758's
unparenthesised `except A, B:`.

The reachability review concluded the walk holds: `ast.walk` descends into
`Interpolation.value` and its `format_spec`, so every forbidden name and
attribute inside a t-string is caught by the existing `ast.Call` and
`ast.Attribute` checks. What it does not hold is *equivalence*. On 3.12 a
t-string is a syntax error and the block is refused; on 3.14 it validates,
executes, and returns a `string.templatelib.Template` into the survey context —
`FlowProcessor._execute_code_block` returns `run_code`'s environment as the new
context, so that object becomes persisted variable state. Nothing in the module
allowlist can consume a `Template`, and `str()` of one yields its repr rather
than interpolated text, so an author who typed `t` for `f` gets a silently wrong
value instead of an error. `ast.TemplateStr` therefore joins the denylist.

Unparenthesised `except` is left permitted: it produces exactly the semantics the
parenthesised form already produced on 3.12, and puts no new object into the
environment.

Two further 3.14 changes reach the sandbox without adding any grammar at all,
which is why a grammar review alone did not find them:

- The module allowlist admitted module *objects*, so its surface was whatever
  the interpreter put on them. 3.14 gave `random` a CLI entry point, and
  `random.main([...])` raises SystemExit — a BaseException, which passed
  through every `except Exception` in the sandbox and in `FlowProcessor`,
  taking the survey out instead of degrading it.
- That instance is closed twice over (the `main$` denial, and the
  `BaseException` conversion at the sandbox boundary). The CLASS is closed by
  `_SAFE_MODULE_MEMBERS`: the sandbox now hands out filtered namespaces built
  from a declaration in this repository, and `TestTheModuleSurfaceIsDeclaredHere`
  fails when a namespace exposes anything the declaration does not name — so the
  next interpreter's additions fail the suite instead of shipping (#697).
- PEP 649/749 changed what an annotated assignment leaves behind: not an
  `__annotations__` dict but `__annotate__`, a live function, plus
  `__conditional_annotations__`. `run_code`'s environment becomes the survey
  context and is persisted into a JSONB column, so neither survives the write.

Tests cover:
- a t-string code block and a t-string expression are both refused, on either
  interpreter and for whichever reason that interpreter can give
- on 3.14 specifically, the refusal is the denylist's, not the parser's
- a module CLI entry point is refused, and SystemExit out of author code becomes
  the sandbox's own error rather than escaping the flow's handlers
- an annotated assignment leaves a JSON-serializable environment
- a forbidden name and a forbidden dunder reached through an interpolation are
  refused, proving the walk descends into the new nodes
- a forbidden attribute hidden in an interpolation's format spec is refused
- `Interpolation` is never reachable without its `TemplateStr` parent, so
  denying the parent is sufficient
- an f-string with the same interpolation is still permitted, so the denial is
  scoped to the new syntax rather than to interpolation generally
- every pre-existing denylist case still rejects, and ordinary code still runs

These unit tests drive the real `PythonRunner` with no mocks. Sources are held as
plain strings so this file parses on 3.12, where the syntax it exercises does not
yet exist.
"""

from __future__ import annotations

import ast
import importlib
import json
import sys
import types

import pytest
from askalot_qml.core.python_runner import CodeExecutionError, PythonRunner

# 3.14 is the first interpreter that parses either construct. Below it the
# parser refuses them, which is the equivalence this module exists to preserve.
ON_314 = sys.version_info >= (3, 14)


def _raise_system_exit() -> None:
    """A `BaseException` that is not an `Exception`, reached from author code.

    Stands in for whatever the next interpreter attaches to an allowlisted
    module. `random.main` was the 3.14 instance and is now refused by two gates,
    so it can no longer exercise the boundary that sits behind them.
    """
    raise SystemExit(2)


# Held as strings: a literal t-string here would make this file unparseable on
# the interpreter the fleet still runs.
T_STRING_ASSIGNMENT = 'name = "x"\nresult = t"hello {name}"'
T_STRING_EXPRESSION = 't"hello {1}"'
T_STRING_DUNDER = 'result = t"{ (1).__class__ }"'
T_STRING_IMPORT = "result = t\"{ __import__('os') }\""
T_STRING_FORMAT_SPEC = 'result = t"{1:{ (1).__class__ }}"'
EXCEPT_WITHOUT_PARENS = "try:\n    x = int('a')\nexcept ValueError, TypeError:\n    x = 0"


@pytest.fixture
def runner() -> PythonRunner:
    return PythonRunner()


@pytest.mark.unit
class TestTemplateStrings:
    """A t-string never reaches the survey context, on either interpreter."""

    @pytest.mark.parametrize(
        "source",
        [T_STRING_ASSIGNMENT, T_STRING_DUNDER, T_STRING_IMPORT, T_STRING_FORMAT_SPEC],
        ids=["plain", "dunder", "import", "format-spec"],
    )
    def test_a_t_string_code_block_is_refused(self, runner: PythonRunner, source: str) -> None:
        assert runner.validate_code(source) is not None

    def test_a_t_string_expression_is_refused(self, runner: PythonRunner) -> None:
        assert runner.validate_expr(T_STRING_EXPRESSION) is not None

    @pytest.mark.skipif(not ON_314, reason="t-strings do not parse before 3.14")
    def test_on_314_the_refusal_is_the_denylist_not_the_parser(
        self, runner: PythonRunner
    ) -> None:
        """A parser refusal would vanish the moment the grammar landed."""
        verdict = runner.validate_code(T_STRING_ASSIGNMENT)

        assert verdict == "Disallowed node type: TemplateStr"

    @pytest.mark.skipif(not ON_314, reason="t-strings do not parse before 3.14")
    def test_running_a_t_string_block_raises_rather_than_returning_a_template(
        self, runner: PythonRunner
    ) -> None:
        """`run_code`'s environment becomes the survey context, so a Template
        landing there would become persisted variable state."""
        with pytest.raises(ValueError, match="Unsafe code"):
            runner.run_code(T_STRING_ASSIGNMENT)

    @pytest.mark.skipif(not ON_314, reason="t-strings do not parse before 3.14")
    def test_the_walk_descends_into_an_interpolation(self) -> None:
        """Denying the parent is what stops these, but the walk reaching the
        children is what makes the denial unnecessary for safety — record both."""
        tree = ast.parse(T_STRING_IMPORT)
        names = {n.id for n in ast.walk(tree) if isinstance(n, ast.Name)}

        assert "__import__" in names

    @pytest.mark.skipif(not ON_314, reason="t-strings do not parse before 3.14")
    def test_interpolation_never_appears_without_its_template_parent(self) -> None:
        """So `TemplateStr` alone is a sufficient denial; `Interpolation` needs none."""
        tree = ast.parse(T_STRING_ASSIGNMENT)
        interpolations = [n for n in ast.walk(tree) if isinstance(n, ast.Interpolation)]
        templates = [n for n in ast.walk(tree) if isinstance(n, ast.TemplateStr)]

        assert interpolations
        assert templates


@pytest.mark.unit
class TestUnparenthesisedExcept:
    """PEP 758 relaxes punctuation; it puts nothing new into the environment."""

    @pytest.mark.skipif(not ON_314, reason="unparenthesised except does not parse before 3.14")
    def test_it_validates_and_behaves_as_the_parenthesised_form(
        self, runner: PythonRunner
    ) -> None:
        assert runner.validate_code(EXCEPT_WITHOUT_PARENS) is None

    def test_the_parenthesised_form_behaves_identically_on_both(
        self, runner: PythonRunner
    ) -> None:
        """The form that parses everywhere is the equivalence anchor.

        The restricted builtins carry no exception classes, so naming one is a
        NameError at run time on either interpreter — the block is refused by
        the environment rather than by the validator, and that is unchanged.
        """
        parenthesised = "try:\n    x = int('a')\nexcept (ValueError, TypeError):\n    x = 0"

        assert runner.validate_code(parenthesised) is None


@pytest.mark.unit
class TestPreExistingDenialsStillHold:
    """The review must not have widened anything while narrowing t-strings."""

    @pytest.mark.parametrize(
        "source",
        [
            "import os",
            "from os import path",
            "result = eval('1')",
            "result = open('/etc/passwd')",
            "result = (1).__class__",
            'result = f"{ (1).__class__ }"',
            "result = getattr(1, 'real')",
            "class Foo:\n    pass",
            "async def f():\n    pass",
        ],
        ids=[
            "import",
            "from-import",
            "eval",
            "open",
            "dunder",
            "f-string-dunder",
            "getattr",
            "class",
            "async-def",
        ],
    )
    def test_each_denial_still_rejects(self, runner: PythonRunner, source: str) -> None:
        assert runner.validate_code(source) is not None

    def test_ordinary_code_still_runs(self, runner: PythonRunner) -> None:
        env = runner.run_code("total = sum([1, 2, 3])\nlabel = f'n={total}'")

        assert env["total"] == 6
        assert env["label"] == "n=6"

    def test_an_ordinary_expression_still_evaluates(self, runner: PythonRunner) -> None:
        assert runner.eval_expr("age >= 18", age=21) is True


@pytest.mark.unit
class TestInterpreterAddedSurfaceOnAllowlistedModules:
    """3.14 widened what allowlisted modules expose, with no grammar change.

    These are the cases a grammar-only review misses: nothing about the source
    an author writes is new, only what the interpreter attached to a module the
    sandbox already trusted.
    """

    def test_a_module_cli_entry_point_is_refused(self, runner: PythonRunner) -> None:
        """`random.main` is an entry point, not author surface."""
        assert runner.validate_code("random.main(['--zz'])") is not None

    def test_the_denial_is_anchored_and_does_not_catch_ordinary_names(
        self, runner: PythonRunner
    ) -> None:
        """`_forbidden_attrs` is matched with `re.match`, so an unanchored
        pattern would also refuse every name merely starting with `main`."""
        assert runner.validate_code("x = maintenance_score") is None
        assert runner.validate_code("x = main_total") is None

    def test_system_exit_from_author_code_becomes_the_sandbox_error(
        self, runner: PythonRunner
    ) -> None:
        """The class fix, isolated from every gate that also covers it today.

        `random.main` is now refused twice over — by the member allowlist and by
        the `main$` denial — so it can no longer reach `exec` and cannot test
        the boundary behind them. A probe module stands in: bound into
        `_safe_modules` with no `_SAFE_MODULE_MEMBERS` entry, so the AST check
        lets it through, which is exactly the position a future interpreter
        addition would occupy if it ever slipped past the allowlist. The
        conversion must hold there.
        """
        runner._safe_modules["probe"] = types.SimpleNamespace(fire=_raise_system_exit)

        with pytest.raises(CodeExecutionError):
            runner.run_code("probe.fire()")

    def test_system_exit_from_an_expression_becomes_a_catchable_error(
        self, runner: PythonRunner
    ) -> None:
        """`FlowProcessor._evaluate_condition` fails open on `Exception`; a
        BaseException would skip that policy entirely."""
        runner._safe_modules["probe"] = types.SimpleNamespace(fire=_raise_system_exit)

        with pytest.raises(Exception) as excinfo:
            runner.eval_expr("probe.fire()")

        assert not isinstance(excinfo.value, SystemExit)

    def test_keyboard_interrupt_is_not_swallowed(self, runner: PythonRunner) -> None:
        """Host control flow must still stop the process — the boundary
        converts author faults, not signals."""

        def _interrupt() -> None:
            raise KeyboardInterrupt

        runner._safe_modules["probe"] = types.SimpleNamespace(fire=_interrupt)

        with pytest.raises(KeyboardInterrupt):
            runner.run_code("probe.fire()")


@pytest.mark.unit
class TestTheModuleSurfaceIsDeclaredHere:
    """The reachable surface is this repository's decision, not CPython's.

    `_safe_modules` used to hold module *objects*, so what a survey author could
    call was whatever the running interpreter attached to them — and an upgrade
    changed it with no diff in this repository and nothing to review. 3.14 was
    the instance: `random` gained a CLI entry point, `random.main([...])` cleared
    every gate, and the denylist could not have refused it because a denylist
    only refuses names somebody already thought of (#697).

    These tests are the deliverable. They convert "an upgrade silently widened
    the sandbox" into a red build.
    """

    def test_no_module_exposes_a_member_this_repository_did_not_declare(self) -> None:
        """The gate. `dir()` of every namespace, minus the declaration, is empty.

        The next interpreter's additions land on the module object, which this
        sandbox no longer hands out — so this asserts the namespaces stay
        exactly what `_SAFE_MODULE_MEMBERS` says.
        """
        runner = PythonRunner()
        for name, namespace in runner._safe_modules.items():
            declared = PythonRunner._SAFE_MODULE_MEMBERS[name]
            exposed = {a for a in dir(namespace) if not a.startswith("__")}
            assert exposed == set(declared), (
                f"{name} exposes {sorted(exposed - set(declared))} beyond its "
                f"declaration and is missing {sorted(set(declared) - exposed)}"
            )

    def test_every_declared_member_actually_exists_on_the_module(self) -> None:
        """The other direction: a declaration naming a member this interpreter
        does not have.

        Asserted against the REAL module, not against the namespace: the
        namespace is built from the declaration, so `hasattr` on it is true by
        construction and the assertion could never fire. Today such a
        declaration raises inside `PythonRunner()`; this says which member and
        which module, and keeps saying so if the namespace is ever built
        defensively (with `getattr(module, member, None)`), where the failure
        would otherwise become a silently absent attribute.
        """
        modules = {
            name: importlib.import_module(name) for name in PythonRunner._SAFE_MODULE_MEMBERS
        }
        for name, members in PythonRunner._SAFE_MODULE_MEMBERS.items():
            for member in members:
                assert hasattr(modules[name], member), (
                    f"{name}.{member} is declared but absent on this interpreter"
                )

    def test_the_declaration_covers_every_module_the_sandbox_binds(self) -> None:
        """Anti-vacuity: a module bound with no declaration escapes the gate.

        `_refuse_attribute` judges by `_SAFE_MODULE_MEMBERS`, so a module in
        `_safe_modules` without an entry would be checked by the denylist alone
        — the pre-#697 behaviour, reintroduced for one module and invisible.
        """
        runner = PythonRunner()
        assert set(runner._safe_modules) == set(PythonRunner._SAFE_MODULE_MEMBERS)

    def test_a_planted_member_is_caught(self) -> None:
        """Anti-vacuity for the gate itself.

        The first test passes trivially if the namespaces were built from the
        declaration and nothing could ever diverge. This proves the assertion
        actually looks: plant an attribute the way an interpreter upgrade would,
        and the same comparison must reject it.
        """
        runner = PythonRunner()
        runner._safe_modules["math"].newly_attached_by_cpython = lambda: None

        declared = PythonRunner._SAFE_MODULE_MEMBERS["math"]
        exposed = {a for a in dir(runner._safe_modules["math"]) if not a.startswith("__")}
        assert exposed != set(declared), "the comparison cannot see a planted member"

    @pytest.mark.parametrize(
        ("source", "refused"),
        [
            ("x = math.floor(3.7)", False),
            ("x = statistics.mean([1, 2, 3])", False),
            ("x = random.randint(1, 6)", False),
            ("x = len(list(itertools.combinations([1, 2, 3], 2)))", False),
            ("x = random.main(['--zz'])", True),
            ("x = functools.MethodType", True),
            ("x = collections.abc", True),
            ("x = statistics.Decimal('1')", True),
            ("x = math.fma(1.0, 2.0, 3.0)", True),
            ("x = itertools.cycle([1, 2])", True),
        ],
        ids=[
            "math.floor", "statistics.mean", "random.randint", "itertools.combinations",
            "random.main", "functools.MethodType", "collections.abc",
            "statistics.Decimal", "math.fma", "itertools.cycle",
        ],
    )
    def test_declared_members_run_and_undeclared_ones_are_refused(
        self, runner: PythonRunner, source: str, refused: bool
    ) -> None:
        """Both directions on real sources.

        The refused half includes the members 3.14 newly attached
        (`math.fma`, `functools.MethodType`, `collections.heapq` and friends) —
        none of which appeared in any diff when the interpreter moved — plus
        `itertools.cycle`, which is refused for a different reason: it is
        unbounded, and this sandbox has no execution deadline.
        """
        problem = runner.validate_code(source)
        if refused:
            assert problem is not None, f"{source!r} was not refused"
        else:
            assert problem is None, f"{source!r} was refused: {problem}"

    def test_an_authors_own_attributes_are_not_judged_against_any_module(
        self, runner: PythonRunner
    ) -> None:
        """The member allowlist must not reach past module receivers.

        Real questionnaires read `.outcome` off item variables and call `.get`,
        `.keys` and `.values` on their own data. A check that judged every
        attribute against a module's declaration would refuse all of it.
        """
        assert runner.validate_code("score = q1.outcome + q2.outcome") is None
        assert runner.validate_code("v = answers.get('q1')") is None
        assert runner.validate_code("ks = list(answers.keys())") is None


@pytest.mark.unit
class TestAnnotatedAssignmentStaysPersistable:
    """PEP 649/749: the environment is written to a JSONB column."""

    @pytest.mark.parametrize(
        "source",
        ['label: str = "years"', "count: int = 0", "ratio: float = 1.5"],
        ids=["str", "int", "float"],
    )
    def test_an_annotated_assignment_leaves_a_serializable_environment(
        self, runner: PythonRunner, source: str
    ) -> None:
        env = runner.run_code(source)

        json.dumps(env)

    def test_the_authors_own_variable_survives_the_strip(
        self, runner: PythonRunner
    ) -> None:
        """Anti-vacuity: a strip that emptied the environment would also pass
        the serialization assertion above."""
        env = runner.run_code('label: str = "years"')

        assert env["label"] == "years"

    def test_no_interpreter_bookkeeping_key_remains(
        self, runner: PythonRunner
    ) -> None:
        env = runner.run_code("count: int = 0")

        assert not [k for k in env if k.startswith("__") and k != "__output__"]
