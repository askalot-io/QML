"""
QML schema version contract tests.

Tests the decoupled Major.Minor.Patch schema-version signal:
- the bundled qml-schema.json carries a top-level `version`
- `version` is valid three-part semver
- `QML_SCHEMA_VERSION` is read from (never hardcoded apart from) the schema
  file — the single-source-of-truth / no-drift guarantee
- the current contract version is 2.7.0 (the 2.0.0 breaking collapse of block
  kinds to Group + Roster, the 2.1.0 backward-compatible addition of the optional
  Roster `subjectFrom` key, the 2.1.1 PATCH tightening that closes the
  Item and Condition objects with `unevaluatedProperties: false`, the 2.2.0
  backward-compatible addition of the optional `external` Item flag, the
  2.3.0 backward-compatible addition of the optional `coding` key on the two
  text controls, the 2.4.0 removal of that same key, the 2.6.0 closing
  of `Input`, and the 2.6.1–2.6.4 PATCH tightenings: identifier item ids,
  whole-number arithmetic, whole-number Range defaults, in-domain defaults,
  and the 2.7.0 backward-compatible optional `invented` postcondition marker)
- the schema version is independent of the askalot_qml package version
- `$defs.Input` is closed (2.6.0): a misspelt or retired key is refused, while
  the keys stored documents carry (Textarea `minLength`, Switch `left` /
  `right`) load
- every committed QML fixture still validates against the schema
- the EBNF grammar rendering carries no `Coding` production
- the EBNF `Questionnaire` production declares no `precondition`/`postcondition`
  (removed at 2.4.1), while `BlockMeta` still declares both
- the loader builds the schema validator once per process (#2246), still
  refuses what the schema refuses, and reads a schema rewritten in place again

These unit tests pin the contract so a schema change cannot silently ship
without a deliberate version move, and the in-code constant can never drift
from the schema file.
"""

import json
import os
import re
from pathlib import Path
from unittest.mock import patch

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader, _schema_validator
from askalot_qml.schema import QML_SCHEMA_VERSION, SCHEMA_PATH
from jsonschema import ValidationError
from jsonschema.validators import validator_for

_SEMVER = re.compile(r"^\d+\.\d+\.\d+$")

#: The module's own fixture corpus — the closest thing to a real-document corpus
#: this suite has. Resolved from this file's location (tests/unit/core/ -> tests/).
FIXTURES_DIR = Path(__file__).resolve().parents[2] / "fixtures"

_GRAMMAR_PATH = SCHEMA_PATH.parent / "qml-grammar.w3c.ebnf"


def _load_schema() -> dict:
    with open(SCHEMA_PATH, encoding="utf-8") as f:
        return json.load(f)


def _fixture_paths() -> list[Path]:
    paths = sorted(FIXTURES_DIR.glob("*.qml"))
    assert paths, f"no .qml fixtures found under {FIXTURES_DIR}"
    return paths


@pytest.mark.unit
class TestSchemaVersionContract:
    def _schema(self) -> dict:
        with open(SCHEMA_PATH, encoding="utf-8") as f:
            return json.load(f)

    def test_schema_declares_top_level_version(self):
        assert "version" in self._schema(), (
            "qml-schema.json must declare a top-level 'version' — it is the "
            "single source of truth for the QML schema contract version."
        )

    def test_schema_version_is_three_part_semver(self):
        assert _SEMVER.match(self._schema()["version"]), (
            "schema 'version' must be Major.Minor.Patch (compatibility semver)"
        )

    def test_constant_is_read_from_schema_no_drift(self):
        # The constant must equal the file value — proves QML_SCHEMA_VERSION is
        # sourced from the schema and cannot drift from a hardcoded copy.
        assert QML_SCHEMA_VERSION == self._schema()["version"]

    def test_current_contract_version_is_2_7_0(self):
        # 2.0.0 was the first breaking (MAJOR) change: block kinds collapse to
        # Group + Roster (Sequence/Sample removed, is_random dropped, kind made
        # optional). 2.1.0 is a backward-compatible (MINOR) addition: the
        # optional Roster `subjectFrom` key. 2.1.1 is a PATCH tightening of an
        # already-de-facto constraint: `unevaluatedProperties: false` on the
        # Item and Condition objects, so a typo'd key (`precondtion`,
        # `postconditions`, `hnt`) is rejected at author time instead of silently
        # doing nothing. 2.2.0 is a backward-compatible (MINOR) addition: the
        # optional boolean `external` Item flag (runtime prefill-eligibility;
        # invisible to Z3, so an external item classifies identically to its
        # non-external twin). 2.3.0 is a backward-compatible (MINOR) addition:
        # the optional `coding` key on the Editbox and Textarea inputs, which
        # opts an open-ended answer into Silver's semantic coding. Analysis
        # selection used to key on `control`, so a text box capturing a street
        # address was clustered like an opinion; the key is on `input` rather
        # than the Item so the per-control branches reject it on a Radio, and
        # it is invisible to Z3 (an item classifies identically with or without
        # it). Every pre-2.3.0 document stays valid — and reads as "do not
        # code", which is why the fleet needed a content migration rather than
        # only a version bump.
        # 2.4.0 REMOVES `coding` again — from the two text branches and from the
        # five non-text refusal branches that existed only because of them. It is
        # MINOR, not MAJOR: `$defs.Input` was still open, so no stored document
        # stopped loading, and the fleet was swept by a content migration plus a
        # standalone leftover guard rather than by the loader. 2.6.0 closed
        # `Input`; see TestInputIsClosed.
        # 2.4.1 REMOVES the questionnaire-level `precondition`/`postcondition`
        # keys. PATCH, where the `coding` removal one line up was MINOR, and the
        # difference is consumption: `coding` was read by seven schema branches,
        # while these two were read by nothing at any layer and appeared in no
        # stored document. The schema stopped advertising a capability it never
        # had — this file's own definition of PATCH.
        # 2.5.0 makes a Range `default` a `[low, high]` pair (Slider keeps an
        # integer) and a Range answer a pair (#1474). MINOR, not MAJOR: a MAJOR
        # bump rejects every 2.x document, while no stored document carried a
        # Range `default` or a condition on a Range outcome on any tenant
        # (checked 2026-10-16), so none stops loading or changes meaning.
        # 2.6.0 closes `Input` with `unevaluatedProperties: false`, so a
        # misspelt input key (`lables`) is refused (#186), and declares the two
        # keys stored documents carried undeclared: Textarea `minLength` (D6)
        # and Switch `left` / `right` (the all-controls sample). MINOR, not
        # MAJOR: every live head and every campaign-pinned version on dev
        # validates closed once those are declared (checked 2026-10-21), and
        # eu1 holds no questionnaire.
        # 2.6.1 refuses an item id that is not a Python identifier (#1783):
        # a condition could never name it, and the Z3 builder's ``@``-joined
        # names rely on it. PATCH: it tightens a de-facto constraint, and no
        # item id on dev breaks it (0 of 2925, checked 2026-10-21).
        # 2.6.2 refuses author code that can produce a fraction (#1813): QML
        # arithmetic is whole numbers, as every answer is (D90). PATCH: none of
        # 1,016 stored dev versions (6,656 code units) uses such a construct,
        # and eu1 holds no questionnaire (checked 2026-10-22).
        # 2.6.3 types a Range default's two ends as integers (#1806), as every
        # Range end already is (#1801). PATCH: none of 1,013 stored dev versions
        # has a fractional Range default, and eu1 holds no questionnaire
        # (checked 2026-10-22).
        # 2.6.4 refuses a control default outside the item's answer domain
        # (#1823). PATCH: all 1,034 stored dev versions (heads and campaign
        # pins) load, 77 carry defaults, none outside its domain (checked 2026-10-24).
        # 2.7.0 is a backward-compatible (MINOR) addition (#1972): the optional
        # boolean `invented` on a postcondition, author metadata marking a check
        # derived rather than stated by the source. Like `external` it is
        # invisible to evaluation: Z3, the walk and the publish gate read a
        # marked check as the same check unmarked, and it is no translation key.
        # A precondition still takes no such key.
        assert QML_SCHEMA_VERSION == "2.7.0"

    def test_schema_version_decoupled_from_package_version(self):
        # Decoupled by policy: a code-only release moves the package version
        # but not the schema. They are not required to be equal and generally
        # are not (the package has its own independent release cadence).
        from askalot_qml import __version__ as package_version

        assert QML_SCHEMA_VERSION != package_version, (
            "schema and package versions are independent; this test documents "
            "the decoupling — it must not assert equality between them"
        )


@pytest.mark.unit
class TestInputIsClosed:
    """`$defs.Input` refuses a key it does not declare (2.6.0, #186).

    Before 2.6.0 the object was open, so a misspelt `lables` or the retired
    `coding` loaded clean and was silently ignored. Closing it needed the two
    keys stored documents still carried to be declared first: Textarea
    `minLength` (D6, pinned by a fielded campaign) and Switch `left` / `right`
    (the all-controls sample, pinned too).
    """

    _DOC = """
qmlVersion: "2.6.0"
questionnaire:
  title: "Input keys"
  blocks:
    - id: "b"
      title: "B"
      items:
        - id: "q"
          title: "Q"
          kind: "Question"
          input:
            control: "Textarea"
"""

    def _load(self, input_lines: str):
        doc = self._DOC.replace('            control: "Textarea"\n', input_lines)
        return QMLLoader().load_from_string(doc)

    def test_the_loader_really_validates_this_document(self):
        """The control for the admissions below: a missing top-level key still raises."""
        with pytest.raises(ValidationError) as exc:
            QMLLoader().load_from_string(self._DOC.replace('qmlVersion: "2.6.0"', ""))
        assert "qmlVersion" in str(exc.value)

    @pytest.mark.parametrize(
        "input_lines",
        [
            '            control: "Radio"\n            lables: {1: "A"}\n            labels: {1: "A"}\n',
            '            control: "Textarea"\n            coding: "semantic"\n',
            '            control: "Editbox"\n            min: 0\n            max: 5\n            step: 1\n',
        ],
        ids=["misspelt-labels", "retired-coding", "step-on-editbox"],
    )
    def test_an_undeclared_input_key_is_refused(self, input_lines):
        with pytest.raises(ValidationError):
            self._load(input_lines)

    @pytest.mark.parametrize(
        ("input_lines", "key"),
        [
            ('            control: "Radio"\n            lables: {1: "A"}\n            labels: {1: "A"}\n', "lables"),
            ('            control: "Editbox"\n            min: 0\n            max: 5\n            step: 1\n', "step"),
        ],
        ids=["misspelt-labels", "step-on-editbox"],
    )
    def test_the_refusal_names_the_undeclared_key_not_input(self, input_lines, key):
        """The Item's cascade "'input' was unexpected" would send the author to delete ``input``."""
        with pytest.raises(ValidationError) as exc:
            self._load(input_lines)
        assert f"'{key}' was unexpected" in exc.value.message
        assert list(exc.value.absolute_path)[-1] == "input"

    def test_a_range_default_is_a_pair_of_whole_numbers(self):
        """#1806: a Range's ends are whole (#1801), so a resting position a
        respondent could never submit unchanged is refused when it loads."""
        with pytest.raises(ValidationError) as exc:
            self._load('            control: "Range"\n            min: 0\n            max: 10\n            default: [2.5, 7.5]\n')
        assert list(exc.value.absolute_path)[-2] == "default"
        self._load('            control: "Range"\n            min: 0\n            max: 10\n            default: [2, 7]\n')

    def test_a_slider_step_is_a_whole_number(self):
        """#1801: no numeric control takes a fractional ``step``, which is what
        lets the answer-domain check refuse every decimal (D90)."""
        with pytest.raises(ValidationError):
            self._load('            control: "Slider"\n            min: 0\n            max: 5\n            step: 0.5\n')
        self._load('            control: "Slider"\n            min: 0\n            max: 10\n            step: 2\n')

    @pytest.mark.parametrize(
        "input_lines",
        [
            '            control: "Textarea"\n            minLength: 10\n            maxLength: 200\n',
            '            control: "Switch"\n            left: "No"\n            right: "Yes"\n',
            # Unquoted, YAML 1.1 reads both captions as booleans; the loader
            # retypes them as it does `on` / `off`.
            '            control: "Switch"\n            left: No\n            right: Yes\n',
        ],
        ids=["textarea-min-length", "switch-left-right", "switch-left-right-unquoted"],
    )
    def test_the_declared_keys_stored_documents_carry_load(self, input_lines):
        self._load(input_lines)


#: Fixtures that do NOT validate against the bundled schema, and have not for as
#: long as the constraints they trip have existed. Both causes predate — and are
#: independent of — anything to do with `coding`:
#:
#: - YAML coerces bare ``Yes``/``No`` label values to booleans, so
#:   ``labels: {1: Yes, 2: No}`` reaches the schema as ``{1: True, 2: False}``
#:   and trips ``Labels.additionalProperties: {type: string}``. Same
#:   YAML-vs-schema family as the Switch ``on:``/``off:`` coercion, which the
#:   loader undoes (``normalize_before_validation``) and these labels it does not.
#: - ``block_preconditions`` and ``dependencies`` additionally carry an Editbox
#:   with no ``min``/``max``, which its branch requires.
#:
#: In every case the failing ``input`` then cascades into an
#: ``unevaluatedProperties`` error on the enclosing Item. The corpus is loaded
#: with ``schema_path=None`` everywhere it is used
#: (``tests/integration/test_qml_parsing.py``), so nothing has ever forced these
#: documents through the schema. Listed rather than skipped so the gap is
#: visible and so the sweep below still guards the other 31 fixtures.
_FIXTURES_THAT_DO_NOT_VALIDATE = frozenset(
    {
        "block_preconditions.qml",
        "branching_flow.qml",
        "classification.qml",
        "cycles.qml",
        "dependencies.qml",
        "malformed_precondition.qml",
        "quality_capped_group.qml",
        "quality_inverted_order.qml",
        "scoring.qml",
    }
)

#: Fixtures that are not YAML at all, on purpose. These are not gaps and will
#: never be fixed: each one exists so a surface can be shown a document that
#: never becomes a questionnaire — the QML Explorer's dev harness renders this
#: corpus to prove the diagram reports the failure itself when there is no
#: graph, no Z3 pass and no item to colour.
#:
#: They are excluded EARLIER than ``_FIXTURES_THAT_DO_NOT_VALIDATE``, and that
#: is the whole reason they are a separate set rather than more names in it.
#: That list holds documents that parse and then fail the schema, so every
#: sweep below can still load them and ask what the schema says. These raise in
#: ``yaml.safe_load``, before a schema is ever consulted — so a sweep that
#: merely skipped its assertion for them would still explode building the
#: document. Folding them together would also invert that list's obligation:
#: it is a shrinking allowance whose rot guard fails when someone repairs an
#: entry, which is a standing invitation to "fix" the file whose brokenness is
#: the point.
_FIXTURES_THAT_DO_NOT_PARSE = frozenset(
    {
        "defect_syntax_error.qml",
    }
)


@pytest.mark.unit
class TestFixtureCorpusValidatesAgainstSchema:
    """The committed fixture corpus, swept against the schema.

    A schema edit is a structural change to the file every document is checked
    against, and this corpus is the only place a mistake in one ``if``/``then``
    branch surfaces as a real document being refused rather than as a unit test
    about a synthetic payload. No other test provides this: the fixtures are
    loaded with ``schema_path=None`` wherever they are used, so the schema is
    not exercised over them at all.

    It is a characterization sweep, not a clean bill of health — see
    ``_FIXTURES_THAT_DO_NOT_VALIDATE`` for what the corpus does not satisfy
    today and why none of it is about `coding`.
    """

    _PATHS = _fixture_paths()

    @staticmethod
    def _document(path: Path) -> dict:
        document = yaml.safe_load(path.read_text(encoding="utf-8"))
        # Unrelated third pre-existing gap: 15 fixtures predate `qmlVersion`
        # becoming a required top-level property. Supplying it in memory points
        # the sweep at the item/input structure a schema edit can actually
        # break, instead of stopping at a document-level omission.
        document.setdefault("qmlVersion", QML_SCHEMA_VERSION)
        # What the loader does before the schema reads a document: give a
        # Switch its ``on`` / ``off`` keys back after YAML 1.1 made them booleans.
        QMLLoader().normalize_before_validation(document.get("questionnaire"))
        return document

    def _errors(self, path: Path) -> list:
        import jsonschema

        return list(jsonschema.Draft202012Validator(_load_schema()).iter_errors(self._document(path)))

    @pytest.mark.parametrize("path", _PATHS, ids=lambda p: p.name)
    def test_fixture_validates(self, path):
        if path.name in _FIXTURES_THAT_DO_NOT_VALIDATE:
            pytest.skip("known pre-existing gap — pinned by the next test")
        if path.name in _FIXTURES_THAT_DO_NOT_PARSE:
            pytest.skip("unparseable on purpose — pinned by its own guard below")
        assert self._errors(path) == []

    @pytest.mark.parametrize("path", _PATHS, ids=lambda p: p.name)
    def test_the_known_bad_list_has_not_rotted(self, path):
        """The allowance must shrink when someone fixes a fixture.

        A stale entry would silently exempt a document that validates fine,
        quietly shrinking the sweep above. Fixing a listed fixture is supposed
        to fail here until its name is removed from the list.
        """
        if path.name not in _FIXTURES_THAT_DO_NOT_VALIDATE:
            pytest.skip("not a listed fixture — covered by the sweep above")
        assert self._errors(path), (
            f"{path.name} now validates — remove it from "
            f"_FIXTURES_THAT_DO_NOT_VALIDATE so the sweep covers it"
        )

    @pytest.mark.parametrize("path", _PATHS, ids=lambda p: p.name)
    def test_an_unparseable_fixture_is_still_unparseable(self, path):
        """A fixture that exists to be refused must still be refused.

        The consumer is the QML Explorer's dev harness, which renders this
        corpus to show what the diagram does with a file that never parses. A
        fixture that quietly starts loading stops demonstrating anything, and
        the harness slug built on it would show a healthy graph under a name
        that promises a defect.

        The assertion is on ``yaml.safe_load`` rather than on schema errors
        because that is where the refusal actually happens — asserting an empty
        schema-error list would pass for a file that loads fine.
        """
        if path.name not in _FIXTURES_THAT_DO_NOT_PARSE:
            pytest.skip("not an unparseable fixture")
        with pytest.raises(yaml.YAMLError):
            yaml.safe_load(path.read_text(encoding="utf-8"))

    @pytest.mark.parametrize("path", _PATHS, ids=lambda p: p.name)
    def test_no_fixture_fails_because_of_the_retired_coding_key(self, path):
        """The assertion this unit actually owns.

        Whatever else the corpus does or does not satisfy, no fixture may fail
        for a reason involving `coding` — neither a leftover declaration nor a
        branch damaged while the seven `coding` blocks were cut out of the
        schema.
        """
        if path.name in _FIXTURES_THAT_DO_NOT_PARSE:
            pytest.skip("unparseable on purpose — there is no document to sweep")
        offending = [e for e in self._errors(path) if "coding" in str(e.message).lower()]
        assert not offending, f"{path.name}: {[e.message for e in offending]}"


_MINIMAL_DOCUMENT = f"""\
qmlVersion: "{QML_SCHEMA_VERSION}"
questionnaire:
  title: "T"
  blocks:
    - id: b
      items:
        - id: q
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 9
"""


@pytest.mark.unit
class TestTheSchemaValidatorIsBuiltOnce:
    """#2246: the loader reads, parses and checks the schema once per process,
    not on every load, and still refuses what the schema refuses."""

    def test_two_loads_build_one_validator(self):
        _schema_validator.cache_clear()
        with patch("askalot_qml.core.qml_loader.validator_for", wraps=validator_for) as built:
            QMLLoader().load_from_string(_MINIMAL_DOCUMENT)
            QMLLoader().load_from_string(_MINIMAL_DOCUMENT)
        assert built.call_count == 1

    def test_the_cached_validator_still_refuses(self):
        QMLLoader().load_from_string(_MINIMAL_DOCUMENT)
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(_MINIMAL_DOCUMENT.replace("max: 9", "max: 9\n            mnLength: 1"))

    def test_a_schema_rewritten_in_place_is_read_again(self, tmp_path):
        schema_file = tmp_path / "schema.json"
        schema_file.write_text(SCHEMA_PATH.read_text(encoding="utf-8"), encoding="utf-8")
        QMLLoader(schema_path=schema_file).load_from_string(_MINIMAL_DOCUMENT)
        schema = _load_schema()
        schema["required"] = [*schema["required"], "notAKey"]
        schema_file.write_text(json.dumps(schema), encoding="utf-8")
        os.utime(schema_file, ns=(0, schema_file.stat().st_mtime_ns + 1_000_000))
        with pytest.raises(ValidationError):
            QMLLoader(schema_path=schema_file).load_from_string(_MINIMAL_DOCUMENT)


@pytest.mark.unit
class TestGrammarTracksTheSchema:
    """The EBNF rendering has no `Coding` production left, and tracks the schema's
    tightenings it renders (the Questionnaire's conditions, a Range pair's ends).

    `qml-grammar.w3c.ebnf` is hand-derived from the schema and there is no
    schema-to-grammar sync test, so a removal that touches only the JSON leaves
    the grammar advertising a key the schema no longer defines. This is the
    cheap standing guard for that one drift.
    """

    def test_grammar_file_exists(self):
        assert _GRAMMAR_PATH.is_file(), (
            f"EBNF rendering not found at {_GRAMMAR_PATH} — the test below "
            f"would pass vacuously against a missing file"
        )

    def test_no_coding_production_or_token_remains(self):
        text = _GRAMMAR_PATH.read_text(encoding="utf-8")
        # Case-insensitive and untargeted: it must catch the `Coding ::=`
        # production, the `( "coding" Coding )?` references on the two text
        # inputs, and the prose comment that explained the opt-in.
        assert "coding" not in text.lower(), (
            "the retired `coding` key still appears in qml-grammar.w3c.ebnf"
        )

    def test_questionnaire_production_declares_no_conditions(self):
        """The `Questionnaire` production must not offer what the schema dropped.

        A whole-file `precondition` search would be wrong here: `BlockMeta` and
        `Item` still carry conditions and always will. The drift this guards is
        scoped to one production, so the assertion is too — it slices the
        `Questionnaire ::=` block and looks only inside it.
        """
        text = _GRAMMAR_PATH.read_text(encoding="utf-8")
        start = text.index("Questionnaire ::=")
        # A production ends at the next blank line followed by a non-indented line.
        production = text[start:].split("\n\n", 1)[0]
        for key in ("precondition", "postcondition"):
            assert key not in production, (
                f"the `Questionnaire` production still declares `{key}`, which "
                f"$defs.Questionnaire dropped at schema 2.4.1:\n{production}"
            )
        # The guard must not have passed by slicing the wrong thing.
        assert "blocks" in production, f"sliced the wrong production:\n{production}"

    def test_block_level_conditions_survive(self):
        """The negative control for the test above.

        Block-level conditions are unaffected by the 2.4.1 removal and are used
        heavily by real instruments. A future edit that deleted them from the
        grammar would satisfy the guard above while breaking the contract.
        """
        text = _GRAMMAR_PATH.read_text(encoding="utf-8")
        start = text.index("BlockMeta     ::=")
        production = text[start:].split("\n\n", 1)[0]
        assert "precondition" in production
        assert "postcondition" in production

    def test_a_range_pair_is_two_integers(self):
        """#1806: the schema types a Range `default`'s ends as integers, so the
        grammar's `RangePair` must not advertise a decimal."""
        text = _GRAMMAR_PATH.read_text(encoding="utf-8")
        start = text.index("RangePair     ::=")
        production = text[start:].split("\n", 1)[0]
        assert production.count("Integer") == 2, production
