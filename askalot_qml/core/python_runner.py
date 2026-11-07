import ast
import functools
import re
from types import SimpleNamespace
from typing import Any

from askalot_common.profiling import profile_block


class CodeExecutionError(Exception):
    """A code block raised while executing its body.

    Carries the environment as it stood when the exception surfaced, because
    the two things the caller needs are in tension: the failure must reach the
    caller (a survey whose code block half-ran is degraded and has to be
    recorded as such), while the assignments that completed before the raise
    must survive (the flow continues on that partial state rather than
    discarding a respondent's progress).

    ``fractional`` names the variables and item proxies a block that ran to
    its end left holding a fraction (#1813), empty for a block that raised:
    names from the author's code, never their values, so a warning may carry
    them (#2190).
    """

    def __init__(self, message: str, local_env: dict, *, fractional: tuple[str, ...] = ()):
        super().__init__(message)
        self.local_env = local_env
        self.fractional = fractional


class CodeRefused(ValueError):
    """Author code refused by AST validation before anything ran.

    ``reason`` is the refusal's own wording, built from the author's code alone
    (``_check_ast_safety`` reads the syntax tree, never a value), so a warning
    may carry it where an exception's text, which can quote a respondent's
    answer, may not (#2190).
    """

    def __init__(self, what: str, reason: str):
        super().__init__(f"{what}: {reason}")
        self.reason = reason


#: Members of the sandbox's modules (``PythonRunner._SAFE_MODULE_MEMBERS``)
#: whose value is a float whatever their arguments. The rest return an int or
#: bool (``math.floor``, ``random.randint``, ``math.isclose``) or pass their
#: arguments' elements through (``random.choice``, ``statistics.mode``).
_FRACTIONAL_MEMBERS: frozenset[tuple[str, str]] = frozenset(
    [("math", name) for name in (
        "copysign", "dist", "e", "exp", "fabs", "fmod", "fsum", "hypot", "inf",
        "log", "log2", "log10", "nan", "pi", "pow", "sqrt", "tau",
    )]
    + [("random", name) for name in (
        "betavariate", "gauss", "normalvariate", "random", "triangular", "uniform",
    )]
    + [("statistics", name) for name in (
        "correlation", "covariance", "fmean", "geometric_mean", "harmonic_mean",
        "linear_regression", "mean", "median", "pstdev", "pvariance", "quantiles",
        "stdev", "variance",
    )]
)

WHOLE_NUMBER_FIX = "use '//' (floor division) or scale first, for example 100 * a // b"


def _negated_exponent(node: ast.AST | None) -> bool:
    """An exponent written negative: a negative int literal, or a unary minus
    or ``~`` over anything (``-1``, ``+-1``, ``-n``, ``~0``). An int raised to
    a negative power is a float. A variable that holds a negative number at
    runtime (``n = -1``, then ``2 ** n``) cannot be told apart from the Roster
    mask idiom ``2 ** count`` by syntax; ``run_code`` refuses the fraction it
    computes (``fraction_in``)."""
    while isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.UAdd):
        node = node.operand
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.USub, ast.Invert)):
        return True
    return isinstance(node, ast.Constant) and type(node.value) is int and node.value < 0


def _pow_call_argument(node: ast.Call, position: int, keyword: str) -> ast.AST | None:
    """The argument ``pow(base, exp, mod)`` binds to *keyword*, positional or not."""
    if len(node.args) > position:
        return node.args[position]
    return next((kw.value for kw in node.keywords if kw.arg == keyword), None)


def fractional_construct(tree: ast.AST) -> str | None:
    """The first construct in *tree* that can produce a non-integer, described
    for an author, or None (#1813).

    QML arithmetic is whole numbers: every answer is whole (D90) and the Z3
    model holds every value as an Int, so a fraction is refused where author
    code enters (``QMLLoader`` and ``PythonRunner``) rather than chased through
    the model. The constructs: ``/`` and ``/=``, a float or complex literal,
    ``float`` / ``complex`` (called or passed on, as in ``map(float, xs)``), a
    power by a negated exponent (``2 ** -1``, ``pow(2, exp=-1)``;
    ``pow(b, e, m)`` with a modulus is modular and whole), ``pow`` passed on
    as a function (``functools.reduce(pow, xs)``), and a float-valued module
    member (``_FRACTIONAL_MEMBERS``). ``//`` and ``%`` stay whole."""
    nodes = list(ast.walk(tree))
    callees = {id(node.func) for node in nodes if isinstance(node, ast.Call)}
    for node in nodes:
        if isinstance(node, (ast.BinOp, ast.AugAssign)):
            if isinstance(node.op, ast.Div):
                return "'/'"
            if isinstance(node.op, ast.Pow) and _negated_exponent(node.right if isinstance(node, ast.BinOp) else node.value):
                return "a power by a negative number"
        elif isinstance(node, ast.Constant) and type(node.value) in (float, complex):
            return f"the number {node.value!r}"
        elif isinstance(node, ast.Name):
            if node.id in ("float", "complex"):
                return f"'{node.id}()'"
            if node.id == "pow" and id(node) not in callees:
                return "'pow' passed on as a function"
        elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == "pow":
            modulus = _pow_call_argument(node, 2, "mod")
            modular = modulus is not None and not (isinstance(modulus, ast.Constant) and modulus.value is None)
            if not modular and _negated_exponent(_pow_call_argument(node, 1, "exp")):
                return "a power by a negative number"
        elif (
            isinstance(node, ast.Attribute)
            and isinstance(node.value, ast.Name)
            and (node.value.id, node.attr) in _FRACTIONAL_MEMBERS
        ):
            return f"'{node.value.id}.{node.attr}'"
    return None


def fraction_in(value: Any) -> bool:
    """Whether *value* holds a float or complex number anywhere: itself, a
    container's members, a Range answer's ends, or an item proxy's outcome.

    The runtime half of whole-number arithmetic (#1813): ``fractional_construct``
    refuses every construct that makes a fraction by its spelling, but a value
    computed at runtime (``2 ** n`` with a negative ``n``) has no spelling to
    refuse, so what a codeBlock leaves behind is checked too."""
    from askalot_qml.core.controls import RangeValue
    from askalot_qml.models.item_proxy import ItemProxy

    pending = [value]
    while pending:
        item = pending.pop()
        if isinstance(item, (float, complex)):
            return True
        if isinstance(item, ItemProxy):
            pending.append(item.outcome)
        elif isinstance(item, RangeValue):
            pending.extend((item.low, item.high))
        elif isinstance(item, dict):
            pending.extend(item.keys())
            pending.extend(item.values())
        elif isinstance(item, (list, tuple, set, frozenset)):
            pending.extend(item)
    return False


class PythonRunner:
    """A secure Python code execution environment that provides controlled access to specific modules and functions.
    This class implements a sandbox for executing Python code with restricted access to modules and built-in functions,
    helping prevent potentially malicious code execution while allowing safe operations.
    Attributes:
        _safe_modules (dict): Dictionary of allowed Python modules including math, random, statistics, etc.
        _safe_builtins (dict): Dictionary of allowed Python built-in functions.
        _forbidden_nodes (set): Set of AST node types that are disallowed.
        _forbidden_attrs (set): Set of attribute patterns that are disallowed.
    Methods:
        safe_print(*args, **kwargs): A wrapper around the built-in print function that prefixes output.
        run_code(code: str, **kwargs) -> dict: Safely executes Python code string in restricted environment.
        eval_expr(expr: str, **kwargs) -> bool: Safely evaluates Python expression and returns boolean result.
        validate_code(code: str) -> Optional[str]: Validates code for safety using AST analysis.
        validate_expr(expr: str) -> Optional[str]: Validates expression for safety using AST analysis.
    Example:
        runner = PythonRunner()
        result = runner.run_code("x = 1 + 1")
        bool_result = runner.eval_expr("2 > 1")
    Note:
        This class provides a secure environment for executing untrusted Python code by limiting available modules and functions.
    """

    #: The members a survey author may reach on each allowlisted module.
    #:
    #: This repository decides the sandbox's surface, not CPython. Admitting the
    #: module *objects* made the reachable set whatever the running interpreter
    #: attached to them, so an upgrade widened what authors could call with no
    #: diff to review — 3.14 gave ``random`` a CLI entry point, and
    #: ``random.main([...])`` cleared every gate (allowlisted module, non-dunder
    #: attribute) before raising ``SystemExit`` (#697).
    #:
    #: Chosen conservatively on evidence: no questionnaire stored on either
    #: tenant, and no ``.qml`` in this repository, calls a single member on any
    #: of these modules. The set is therefore what a questionnaire could
    #: reasonably want rather than what happened to be in use, and widening it
    #: is a one-line change with a test that says so.
    #:
    #: Two deliberate omissions:
    #: * ``itertools.count``/``cycle``/``repeat`` — unbounded iterators. The
    #:   sandbox has no execution deadline, so ``list(itertools.cycle(xs))``
    #:   hangs the request rather than failing it.
    #: * ``re.compile`` — already unreachable, and left that way. It is matched
    #:   by the unanchored ``compile`` entry in ``_forbidden_attrs``; the module
    #:   functions below take a pattern string and cover the same ground.
    _SAFE_MODULE_MEMBERS: dict[str, frozenset[str]] = {
        "math": frozenset({
            "ceil", "comb", "factorial", "floor", "gcd", "isclose", "isfinite",
            "isinf", "isnan", "lcm", "perm", "prod", "trunc",
        }),
        "random": frozenset({
            "choice", "choices", "randint", "randrange", "sample", "seed", "shuffle",
        }),
        "statistics": frozenset({
            "median_high", "median_low", "mode", "multimode",
        }),
        "itertools": frozenset({
            "accumulate", "batched", "chain", "combinations", "compress",
            "dropwhile", "filterfalse", "groupby", "islice", "pairwise",
            "permutations", "product", "starmap", "takewhile", "zip_longest",
        }),
        "functools": frozenset({"cmp_to_key", "partial", "reduce"}),
        "collections": frozenset({
            "Counter", "OrderedDict", "defaultdict", "deque", "namedtuple",
        }),
        "re": frozenset({
            "DOTALL", "IGNORECASE", "MULTILINE", "escape", "findall", "finditer",
            "fullmatch", "match", "search", "split", "sub", "subn",
        }),
    }

    def __init__(self):
        import collections
        import functools
        import itertools
        import math
        import random
        import re
        import statistics

        # Filtered namespaces, not the modules themselves: what an author can
        # reach is the declaration above, so the next interpreter's additions
        # are not silently in scope. `SimpleNamespace` keeps `_safe_modules` a
        # plain name -> object mapping, which `sandbox_names`
        # reads the KEYS of for the undefined-name lint, and which the suite
        # injects a probe object into.
        self._safe_modules = {
            name: SimpleNamespace(
                **{member: getattr(module, member) for member in members}
            )
            for name, module, members in (
                (n, m, self._SAFE_MODULE_MEMBERS[n])
                for n, m in (
                    ("math", math),
                    ("random", random),
                    ("statistics", statistics),
                    ("itertools", itertools),
                    ("functools", functools),
                    ("collections", collections),
                    ("re", re),
                )
            )
        }

        self._safe_builtins = {
            "abs": abs,
            "all": all,
            "any": any,
            "ascii": ascii,
            "bin": bin,
            "bool": bool,
            "chr": chr,
            "divmod": divmod,
            "enumerate": enumerate,
            "filter": filter,
            "format": format,
            "hash": hash,
            "hex": hex,
            "int": int,
            "isinstance": isinstance,
            "issubclass": issubclass,
            "iter": iter,
            "len": len,
            "list": list,
            "map": map,
            "max": max,
            "min": min,
            "next": next,
            "oct": oct,
            "ord": ord,
            "pow": pow,
            "range": range,
            "repr": repr,
            "reversed": reversed,
            "round": round,
            "set": set,
            "slice": slice,
            "sorted": sorted,
            "str": str,
            "sum": sum,
            "tuple": tuple,
            "zip": zip,
            "print": self.safe_print,
        }

        # Store captured print output
        self.captured_output = []

        # Define forbidden node types for AST analysis
        self._forbidden_nodes = {
            ast.Import,
            ast.ImportFrom,  # No imports
            ast.AsyncFunctionDef,
            ast.ClassDef,  # No class or async function definitions
            ast.Await,
            ast.AsyncFor,
            ast.AsyncWith,  # No async operations
        }

        # PEP 750 t-strings. Denied for what they PRODUCE, not for what they can
        # reach: `_check_ast_safety` walks into an `Interpolation`'s value and
        # format spec, so a forbidden name or attribute inside one is already
        # caught by the Call and Attribute checks below. What a t-string yields
        # is a `string.templatelib.Template`, and `run_code`'s environment
        # becomes the survey context (`FlowProcessor._execute_code_block`) — so
        # the object lands in persisted variable state, where no allowlisted
        # module can consume it and `str()` of it gives a repr rather than
        # interpolated text. An author who typed `t` for `f` would get a
        # silently wrong value instead of an error.
        #
        # Guarded because this module runs on interpreters that predate the node
        # type; there the syntax is a parse error and the block is refused
        # anyway, which is the equivalence this denial preserves.
        if hasattr(ast, "TemplateStr"):
            self._forbidden_nodes.add(ast.TemplateStr)

        # Define forbidden attribute patterns
        self._forbidden_attrs = {
            "__.+__",  # No dunder methods
            # Anchored: these patterns are matched with `re.match`, so a bare
            # "main" would also refuse `maintenance` and `main_score`. Module
            # CLI entry points are not author surface — `random.main` arrived
            # with 3.14 and writes argparse usage to the container's stderr on
            # its way to raising SystemExit.
            "main$",
            "eval",
            "exec",
            "compile",  # No code execution
            "open",
            "file",
            "os",
            "sys",  # No file/system access
            "globals",
            "locals",
            "getattr",
            "setattr",  # No dynamic attribute access
            "subprocess",
            "importlib",  # No subprocess or dynamic imports
            "builtins",
            "__import__",  # No access to builtin imports
            "socket",
            "requests",  # No network access
        }

    def safe_print(self, *args, **kwargs):
        """A safe wrapper around the built-in print function that captures output"""
        # Convert args to string and join them
        output_str = " ".join(str(arg) for arg in args)

        # Add any keyword arguments that might affect formatting
        if "sep" in kwargs:
            output_str = kwargs["sep"].join(str(arg) for arg in args)

        # Capture the output
        self.captured_output.append(output_str)

        # Also print to console for debugging
        print("print:", output_str, **kwargs)

    def validate_code(self, code: str) -> str | None:
        """
        Validate code for safety using AST analysis.

        Args:
            code: The Python code to validate

        Returns:
            None if the code is safe, or an error message if unsafe
        """
        try:
            # Parse the code into an AST
            tree = ast.parse(code)

            # Check for disallowed constructs
            return self._check_ast_safety(tree)
        except SyntaxError as e:
            return f"Syntax error: {e}"
        except Exception as e:
            return f"Validation error: {e}"

    def validate_expr(self, expr: str) -> str | None:
        """
        Validate expression for safety using AST analysis.

        Args:
            expr: The Python expression to validate

        Returns:
            None if the expression is safe, or an error message if unsafe
        """
        try:
            # Parse the expression into an AST
            tree = ast.parse(expr, mode="eval")

            # Check for disallowed constructs
            return self._check_ast_safety(tree)
        except SyntaxError as e:
            return f"Syntax error: {e}"
        except Exception as e:
            return f"Validation error: {e}"

    def _check_ast_safety(self, tree: ast.AST) -> str | None:
        """
        Check if an AST is safe to execute.

        Args:
            tree: The AST to check

        Returns:
            None if the tree is safe, or an error message if unsafe
        """
        fractional = fractional_construct(tree)
        if fractional:
            return (
                f"QML arithmetic is whole numbers: {fractional} can produce a "
                f"fraction; {WHOLE_NUMBER_FIX}"
            )
        for node in ast.walk(tree):
            # Check node type
            if type(node) in self._forbidden_nodes:
                return f"Disallowed node type: {type(node).__name__}"

            # Check for Call nodes
            if isinstance(node, ast.Call):
                # Check if it's a direct function call
                if isinstance(node.func, ast.Name):
                    func_name = node.func.id
                    if func_name not in self._safe_builtins and func_name not in self._safe_modules:
                        return f"Call to disallowed function: {func_name}"
                # Check if it's an attribute call
                elif isinstance(node.func, ast.Attribute):
                    refusal = self._refuse_attribute(node.func, "Call to")
                    if refusal:
                        return refusal

            # Check attribute access
            elif isinstance(node, ast.Attribute):
                refusal = self._refuse_attribute(node, "Access to")
                if refusal:
                    return refusal

        return None  # No issues found

    def _refuse_attribute(self, node: ast.Attribute, verb: str) -> str | None:
        """Judge one attribute access, resolving what it sits on.

        Two rules, in this order:

        1. The member allowlist, when the receiver is a bare name that NAMES an
           allowlisted module. `math.floor` is judged against `math`'s declared
           members; `q1.outcome` is not judged against anything, because `q1` is
           an author's own variable and its attributes are not this sandbox's
           business (real questionnaires read `.outcome` and call `.get`,
           `.keys`, `.values` on their own data).

           The rule is syntactic on purpose: this is an AST walk with no scope
           analysis, so a name is matched rather than resolved. An author who
           shadows `math` (or `re`, or `random`) with a variable of their own is
           therefore judged against the module's declaration and refused — a
           false refusal, but the only direction that is safe to be wrong in,
           since resolving the name would mean trusting an assignment the walk
           has not executed. No stored questionnaire on either tenant, and no
           `.qml` in this repository, binds any of these seven names.
        2. `_forbidden_attrs`, unchanged, applied to every attribute regardless
           of receiver. It stays as defence in depth rather than the boundary —
           a denylist can only refuse names somebody already thought of, which
           is how `random.main` arrived (#697).

        A module bound into ``_safe_modules`` with no entry in
        ``_SAFE_MODULE_MEMBERS`` is judged by rule 2 alone. Nothing in
        production does that; the suite does, to exercise the sandbox's error
        boundary with a probe object.
        """
        if isinstance(node.value, ast.Name):
            members = self._SAFE_MODULE_MEMBERS.get(node.value.id)
            if members is not None and node.attr not in members:
                return (
                    f"{verb} disallowed attribute: {node.value.id}.{node.attr}. "
                    f"This sandbox declares which members of {node.value.id} a "
                    "questionnaire may use, so that an interpreter upgrade "
                    "cannot widen it silently."
                )

        for pattern in self._forbidden_attrs:
            if re.match(pattern, node.attr):
                return f"{verb} disallowed attribute: {node.attr}"
        return None

    @staticmethod
    def _strip_interpreter_bookkeeping(env: dict) -> None:
        """Remove the interpreter's own annotation bookkeeping from *env*.

        The environment `run_code` returns becomes the survey context, which
        `FlowProcessor` deep-copies onto every item and the repository persists
        into `Survey.qml_state` — a JSONB column. So everything left in here has
        to be JSON-serializable, and none of these keys is an author variable.

        Under PEP 649/749, default from 3.14, an annotated assignment no longer
        leaves an `__annotations__` dict behind: `label: str = "years"` leaves
        `__annotate__`, a live function object, plus `__conditional_annotations__`,
        a set. Neither survives `json.dumps`, so a codeBlock that persisted
        respondent progress before the interpreter moved failed at the database
        write afterwards — past every handler the flow has, for every respondent
        reaching that item. `__annotations__` is stripped in the same breath
        because it was never serializable either (`count: int = 0` left
        `{'count': <class 'int'>}`); it simply had not been reached by a caller
        that persisted the environment.
        """
        for key in ("__annotate__", "__conditional_annotations__", "__annotations__"):
            env.pop(key, None)

    def run_code(self, code: str, **kwargs) -> dict:
        """
        Safely execute code and return the local environment.

        Args:
            code: The Python code to execute
            **kwargs: Variables to include in the local environment

        Returns:
            A dictionary of the local environment after execution and captured output

        Raises:
            CodeRefused: If the code contains disallowed constructs (a ValueError)
            CodeExecutionError: If the code raises while executing; the partial
                environment travels on the exception
        """
        with profile_block("qml_run_code"):
            # Clear any previous captured output
            self.captured_output = []

            # Validate code safety
            error = self.validate_code(code)
            if error:
                raise CodeRefused("Unsafe code", error)

            # Set up execution environment
            global_env = {"__builtins__": self._safe_builtins, **self._safe_modules}

            local_env = {**kwargs}

            # A fraction already in the input (a value stored before #1813)
            # is not this block's doing; only one it makes is refused.
            held_before = {name for name, value in local_env.items() if fraction_in(value)}

            # Execute the code safely
            try:
                exec(code, global_env, local_env)
            except KeyboardInterrupt:
                # Host control flow, never author-caused: re-raise untouched so
                # a SIGINT still stops the process. `asyncio.CancelledError` is
                # the other BaseException a caller could care about and cannot
                # arrive here — it is delivered at an await point, and author
                # code is synchronous by construction (no async grammar reaches
                # `exec`, `_forbidden_nodes` sees to that).
                raise
            except BaseException as e:
                # BaseException, not Exception: an allowlisted module's members
                # are whatever the interpreter puts on them, so the sandbox does
                # not get to assume author code only raises `Exception`. Python
                # 3.14 gave `random` a CLI entry point, and `random.main([...])`
                # — allowlisted module, non-dunder attribute — raises SystemExit,
                # which passed straight through an `except Exception` here, then
                # through FlowProcessor's `except CodeExecutionError` /
                # `except Exception`, then through `_evaluate_condition`'s
                # fail-open handler. Nothing in the flow catches BaseException,
                # so one saved questionnaire took the survey out with an
                # unhandled exception instead of the documented degradation
                # (record a critical warning, keep the partial environment,
                # exclude the survey from dataset construction). Catching the
                # class rather than the instance is what keeps the next
                # interpreter's additions inside the contract.
                local_env["__output__"] = self.captured_output
                self._strip_interpreter_bookkeeping(local_env)
                self._drop_fractions(local_env, held_before)
                # The failure is raised rather than reported through a key in
                # the returned environment: a returned environment is
                # indistinguishable from a successful run unless every caller
                # remembers to look, and none did.
                raise CodeExecutionError(str(e), local_env) from e

            # Add the captured output to the environment
            local_env["__output__"] = self.captured_output
            self._strip_interpreter_bookkeeping(local_env)
            fractional = self._drop_fractions(local_env, held_before)
            if fractional:
                raise CodeExecutionError(
                    f"QML arithmetic is whole numbers: {', '.join(map(repr, fractional))} "
                    f"computed a fraction at runtime; {WHOLE_NUMBER_FIX}",
                    local_env,
                    fractional=tuple(fractional),
                )
            return local_env

    @staticmethod
    def _drop_fractions(env: dict, held_before: set[str]) -> list[str]:
        """Remove every variable whose value holds a fraction from *env*, and
        name it with every item proxy that holds one; an empty list when there
        is none. A fraction no spelling revealed (``2 ** n`` with a negative
        ``n``) must not become survey state the Z3 model cannot hold: the
        variable is gone, as after a block that raised before assigning it, and
        the run fails as a ``critical`` codeBlock error (#1813). A proxy is
        named, not reset: its write-back is the flow's, and the critical
        warning already excludes the survey from datasets."""
        from askalot_qml.models.item_proxy import ItemProxy

        found: list[str] = []
        for name in [n for n in env if n != "__output__" and n not in held_before]:
            if fraction_in(env[name]):
                found.append(name)
                if not isinstance(env[name], ItemProxy):
                    del env[name]
        return found

    def eval_expr(self, expr: str, **kwargs) -> bool:
        """
        Safely evaluate an expression and return the result as a boolean.

        Args:
            expr: The Python expression to evaluate
            **kwargs: Variables to include in the local environment

        Returns:
            The boolean result of the expression

        Raises:
            CodeRefused: If the expression contains disallowed constructs (a ValueError)
        """
        with profile_block("qml_eval_expr"):
            # Validate expression safety
            error = self.validate_expr(expr)
            if error:
                raise CodeRefused("Unsafe expression", error)

            # Set up evaluation environment
            global_env = {"__builtins__": self._safe_builtins, **self._safe_modules}

            local_env = {**kwargs}

            # Evaluate the expression safely
            # Raises on error so FlowProcessor._evaluate_condition can
            # apply its fail-open policy (return True + log warning).
            # That policy is written as `except Exception`, so a BaseException
            # out of author code would skip it and take the survey down instead
            # of skipping the condition — see `run_code` for the `random.main`
            # case that made this reachable. Re-raised as a RuntimeError so the
            # caller's existing handler sees something it is written to catch.
            try:
                result = eval(expr, global_env, local_env)
            except KeyboardInterrupt:
                raise
            except Exception:
                raise
            except BaseException as e:
                raise RuntimeError(f"Expression raised {type(e).__name__}") from e
            return bool(result)

    def eval_value(self, expr: str, **kwargs):
        """
        Safely evaluate an expression and return the RAW result (no bool coercion).

        Use this for non-predicate expressions where the natural type matters —
        e.g., Roster `iterateOver` which must resolve to an int bitmask.
        For boolean predicates (preconditions / postconditions) keep using
        eval_expr() to preserve the long-standing fail-open contract.

        Raises:
            CodeRefused: If the expression contains disallowed constructs (a ValueError).
            Anything raised by `eval` (NameError, TypeError, …) bubbles up so
            the caller can decide policy (e.g., FlowProcessor surfaces a
            survey warning and treats the roster pass as empty).
        """
        with profile_block("qml_eval_value"):
            error = self.validate_expr(expr)
            if error:
                raise CodeRefused("Unsafe expression", error)

            global_env = {"__builtins__": self._safe_builtins, **self._safe_modules}
            local_env = {**kwargs}
            # Same boundary rule as `eval_expr`: the caller decides policy from
            # an `Exception`, so nothing may leave here as a BaseException.
            try:
                value = eval(expr, global_env, local_env)
            except KeyboardInterrupt:
                raise
            except Exception:
                raise
            except BaseException as e:
                raise RuntimeError(f"Expression raised {type(e).__name__}") from e
            if fraction_in(value):
                raise ValueError(
                    # The value is never named: it is computed from answers.
                    f"QML arithmetic is whole numbers: the expression computed a "
                    f"fraction; {WHOLE_NUMBER_FIX}"
                )
            return value


@functools.cache
def sandbox_names() -> frozenset[str]:
    """The builtin and module names the sandbox binds in every condition and
    codeBlock: the undefined-name lint's known names, and the item ids the
    loader refuses, since an item bound under one of them would shadow it."""
    runner = PythonRunner()
    return frozenset(runner._safe_builtins) | frozenset(runner._safe_modules)
