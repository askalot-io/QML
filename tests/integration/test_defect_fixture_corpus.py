"""Each defect fixture actually exhibits the defect its name claims.

The five `defect_*.qml` fixtures are the QML Explorer's diagram corpus: each one
is supposed to be the smallest instrument that produces one finding class, so the
harness can render every treatment. Until #762 the claim rested entirely on a
**hand-written comment at the top of each file** — nothing loaded them and
asserted anything, so a fixture whose defect was accidentally repaired (a rename,
a reindent, a schema change that made the construct legal) would go on being
described as a defect fixture while exhibiting nothing.

That is the same shape as a guard that cannot fail: the corpus reports the same
green whether it is correct or empty.

Tests:
- Every fixture named `defect_*.qml` is in the expectation table, so adding one
  without an expectation fails rather than joining silently.
- Each parseable fixture's `ValidationProcessor.to_issues()` emits its claimed
  finding type.
- The syntax-error fixture fails to PARSE, which is its defect — it has no
  finding type because it never becomes a questionnaire.
- `defect_dead_end` is order-dependent, and the committed order is the one that
  produces the finding.
- The corpus is non-empty, so a glob that stopped matching cannot read as a pass.

These integration tests run the real loader and the real Z3-backed processor
against the real fixture files — a mocked processor would assert the table I
wrote rather than what the corpus contains.
"""

from __future__ import annotations

from pathlib import Path

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

FIXTURE_DIR = Path(__file__).resolve().parent.parent / "fixtures"

#: fixture stem -> the `to_issues()` type it must emit, or None when its defect
#: is that the file never parses.
#:
#: This table is the expectation that used to live in each file's comment. The
#: comments now point here, because a claim in a file nothing executes is how
#: #762 happened.
EXPECTED_FINDING: dict[str, str | None] = {
    "defect_cycle": "dependency_cycle",
    "defect_dead_end": "infeasible_postcondition",
    "defect_unreachable": "unreachable_item",
    "defect_unsupported_python": "unsafe_code",
    "defect_syntax_error": None,
}


def _fixture_stems() -> list[str]:
    return sorted(p.stem for p in FIXTURE_DIR.glob("defect_*.qml"))


def _issues_for(stem: str) -> list[dict]:
    content = (FIXTURE_DIR / f"{stem}.qml").read_text(encoding="utf-8")
    # Through the loader, not a bare yaml.safe_load: the loader unwraps the
    # `questionnaire:` root key. Handing QMLState the raw mapping yields a state
    # with no blocks and no items, which reports a clean sweep for every input —
    # a green that measures nothing.
    state = QMLState(QMLLoader(schema_path=None).load_from_string(content))
    return ValidationProcessor(state).to_issues()


@pytest.mark.integration
class TestEachDefectFixtureExhibitsItsDefect:
    def test_the_corpus_is_not_empty(self):
        """A glob that stopped matching would make every case below vacuous."""
        stems = _fixture_stems()
        assert len(stems) >= 5, stems

    def test_every_fixture_has_a_declared_expectation(self):
        """Adding a fixture without an expectation must fail, not join silently.

        The defect this file exists for is a corpus member whose claim is
        recorded nowhere executable; a new member with no entry would be exactly
        that again.
        """
        undeclared = [s for s in _fixture_stems() if s not in EXPECTED_FINDING]
        assert not undeclared, (
            f"defect fixtures with no declared expected finding: {undeclared} — "
            "add them to EXPECTED_FINDING rather than describing them in a comment"
        )

    @pytest.mark.parametrize(
        "stem", [s for s, code in EXPECTED_FINDING.items() if code is not None]
    )
    def test_the_fixture_emits_its_claimed_finding(self, stem):
        expected = EXPECTED_FINDING[stem]
        types = {issue.get("type") for issue in _issues_for(stem)}
        assert expected in types, (
            f"{stem}.qml is described as a {expected!r} fixture but emits "
            f"{sorted(t for t in types if t)} — "
            "either the fixture's defect was repaired or the finding was renamed"
        )

    def test_the_syntax_fixture_fails_to_parse(self):
        """Its defect IS the parse failure, so it has no finding type.

        Asserting a finding for it would be asserting that the file becomes a
        questionnaire, which is the opposite of what it demonstrates.
        """
        content = (FIXTURE_DIR / "defect_syntax_error.qml").read_text(encoding="utf-8")
        with pytest.raises(Exception):  # noqa: B017 - the loader's error type is not the claim
            QMLLoader(schema_path=None).load_from_string(content)

    def test_dead_end_is_order_dependent_and_the_committed_order_is_right(self):
        """The finding depends on the two items' order, which a reorder would lose.

        Recorded here rather than in a comment on the fixture: a future edit that
        reorders them should fail this test rather than silently stop
        demonstrating the defect. The assertion is the committed order producing
        the finding; the order dependence itself is what this docstring pins.
        """
        types = [issue.get("type") for issue in _issues_for("defect_dead_end")]
        assert "infeasible_postcondition" in types, types
