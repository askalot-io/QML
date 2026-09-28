"""
QML schema version contract tests.

Tests the decoupled Major.Minor.Patch schema-version signal:
- the bundled qml-schema.json carries a top-level `version`
- `version` is valid three-part semver
- `QML_SCHEMA_VERSION` is read from (never hardcoded apart from) the schema
  file — the single-source-of-truth / no-drift guarantee
- the current contract version is 2.4.0 (the 2.0.0 breaking collapse of block
  kinds to Group + Roster, the 2.1.0 backward-compatible addition of the optional
  Roster `subjectFrom` key, the 2.1.1 PATCH tightening that closes the
  Item and Condition objects with `unevaluatedProperties: false`, the 2.2.0
  backward-compatible addition of the optional `external` Item flag, the
  2.3.0 backward-compatible addition of the optional `coding` key on the two
  text controls, and the 2.4.0 removal of that same key)
- the schema version is independent of the askalot_qml package version
- a document still declaring the retired `coding` key is ADMITTED, not
  rejected — `$defs.Input` is open, so the schema is not the tripwire
- every committed QML fixture still validates against the schema
- the EBNF grammar rendering carries no `Coding` production
- the EBNF `Questionnaire` production declares no `precondition`/`postcondition`
  (removed at 2.4.1), while `BlockMeta` still declares both

These unit tests pin the contract so a schema change cannot silently ship
without a deliberate version move, and the in-code constant can never drift
from the schema file.
"""

import json
import re
from pathlib import Path

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.schema import QML_SCHEMA_VERSION, SCHEMA_PATH
from jsonschema import ValidationError

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

    def test_current_contract_version_is_2_4_1(self):
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
        # MINOR, not MAJOR: `$defs.Input` is open, so no stored document stops
        # loading, and the fleet is swept by a content migration plus a
        # standalone leftover guard rather than by the loader. See
        # TestRetiredCodingKeyIsSilentlyAdmitted for what that openness costs.
        # 2.4.1 REMOVES the questionnaire-level `precondition`/`postcondition`
        # keys. PATCH, where the `coding` removal one line up was MINOR, and the
        # difference is consumption: `coding` was read by seven schema branches,
        # while these two were read by nothing at any layer and appeared in no
        # stored document. The schema stopped advertising a capability it never
        # had — this file's own definition of PATCH.
        assert QML_SCHEMA_VERSION == "2.4.1"

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
class TestRetiredCodingKeyIsSilentlyAdmitted:
    """The retired `coding` key still VALIDATES — the schema is not the tripwire.

    `coding` was removed at 2.4.0, but `$defs.Input` carries no
    `unevaluatedProperties`, so an unnamed key is ADMITTED rather than
    forbidden. A stored document that still declares `coding: semantic`
    therefore loads clean and the key is silently ignored — nothing reads it.

    These tests exist so a later reader cannot mistake the schema for the thing
    that enforces the removal's completeness. It is not: a content migration
    sweeps the fleet's stored documents, and a standalone leftover guard is what
    catches a survivor. Asserting the admission (rather than a refusal that does
    not exist) is what keeps that distinction discoverable from the tests.
    """

    #: A whole document, not a bare `$defs.Input` payload — the point is that
    #: the real loader's schema-validation step admits it end to end.
    _DOC = """
qmlVersion: "2.4.0"
questionnaire:
  title: "A document that still declares the retired key"
  blocks:
    - id: "b_open"
      title: "Open ends"
      items:
        - id: "q_why"
          title: "Why did you choose that?"
          kind: "Question"
          input:
            control: "Textarea"
            coding: "semantic"
        - id: "q_mood"
          title: "How do you feel about it?"
          kind: "Question"
          input:
            control: "Radio"
            labels: {1: "Good", 2: "Bad"}
            coding: "semantic"
"""

    def test_the_loader_really_validates_this_document(self):
        """The control for the two tests below.

        Both assert that something is NOT rejected, which a loader that skipped
        schema validation would also satisfy — the assertions would pass while
        proving nothing. Removing a required top-level key must still raise, so
        the admission below is a real verdict rather than a skipped step.
        """
        with pytest.raises(ValidationError) as exc:
            QMLLoader().load_from_string(self._DOC.replace('qmlVersion: "2.4.0"', ""))
        assert "qmlVersion" in str(exc.value)

    def test_a_text_control_still_declaring_coding_is_admitted(self):
        data = QMLLoader().load_from_string(self._DOC)
        stray = next(i for i in data["items"] if i["id"] == "q_why")
        # Admitted AND carried through verbatim: the loader neither rejects nor
        # strips it. Nothing downstream reads it, which is exactly why a
        # leftover is invisible without the dedicated guard.
        assert stray["input"]["coding"] == "semantic"

    def test_a_non_text_control_declaring_coding_is_now_admitted_too(self):
        """The five refusal branches went with the two permissive ones.

        Before 2.4.0 a Radio naming `coding` was rejected — those refusals were
        spelled out precisely because `$defs.Input` is open. Removing the
        permissive branches without the refusals would have left the schema
        refusing a key nothing implements, so they were deleted together and a
        Radio now admits it like every other control.
        """
        data = QMLLoader().load_from_string(self._DOC)
        stray = next(i for i in data["items"] if i["id"] == "q_mood")
        assert stray["input"]["coding"] == "semantic"


#: Fixtures that do NOT validate against the bundled schema, and have not for as
#: long as the constraints they trip have existed. Both causes predate — and are
#: independent of — anything to do with `coding`:
#:
#: - YAML coerces bare ``Yes``/``No`` label values to booleans, so
#:   ``labels: {1: Yes, 2: No}`` reaches the schema as ``{1: True, 2: False}``
#:   and trips ``Labels.additionalProperties: {type: string}``. Same
#:   YAML-vs-schema family as the Switch ``on:``/``off:`` coercion that keeps
#:   ``$defs.Input`` open in the first place.
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


@pytest.mark.unit
class TestGrammarTracksTheSchema:
    """The EBNF rendering has no `Coding` production left.

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
