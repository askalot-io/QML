"""
Repository-wide gate: no production code reads OR writes QML on the
organizations tree (plan 2026-07-21-001 — U5 read side, U7 write side).

QML content is canonical in Postgres. Filesystem I/O is not merely a style
issue: it silently reintroduces the divergence the document store exists to
remove — a fielded survey served bytes that no version row records, an MCP tool
grading a file the head has moved past, an edit that no version attributes to
anyone (R13).

Tests that, across the whole monorepo's non-test Python:

- no module scans the organizations tree for ``*.qml`` (``rglob``/``glob``)
- no module constructs a ``QMLLoader`` bound to an ``ORGANIZATIONS_DIR``-derived
  directory
- no module WRITES a ``.qml`` path — ``write_text``/``os.replace``/``shutil.move``
  onto a QML target, or the retired ``create_questionnaire_file`` family
- the allowlist itself stays honest — every entry names a file that exists and
  carries a written reason
- the allowlist admits only one sanctioned QML-reading surface: the loader's
  own filesystem branch (fixtures and the CLI)
- the ``shared/modules`` + ``services`` production trees are actually reached by
  the scan, so a mis-rooted run cannot pass vacuously

This integration test greps real source rather than mocking an import graph:
the bug class is textual (a re-added ``rglob``, a re-added ``write_text``), so a
textual gate is the one that catches it, and it runs in CI with no database or
service.
"""

import re
from pathlib import Path

import pytest

#: Signatures of a filesystem QML read. Both are on the org tree today only via
#: the allowlisted files below.
_QML_GLOB = re.compile(r"r?glob\(\s*[\"']\*\.qml[\"']\s*\)")
_ORG_DIR_LOADER = re.compile(r"ORGANIZATIONS_DIR")

#: Signatures of a filesystem QML WRITE (U7). Three shapes, because that is how
#: many ways the pre-document code had of landing bytes: a direct ``write_text``
#: on a ``.qml`` path, the atomic tmp+``os.replace`` dance, and a ``shutil.move``
#: of a ``.qml`` into place. The retired helper names are matched by name too —
#: a re-introduced ``create_questionnaire_file`` would fail on import anyway, but
#: naming it here says WHY rather than leaving a NameError to explain itself.
_QML_WRITE_SIGNATURES = (
    re.compile(r"qml[_a-z]*(path|target|file)\w*\.write_text\("),
    re.compile(r"write_text\([^)]*\)\s*#\s*qml", re.IGNORECASE),
    re.compile(r"os\.replace\(.*\.qml"),
    re.compile(r"shutil\.move\(.*\.qml"),
    re.compile(r"\.qml[\"']\s*\)?\s*\.write_text\("),
    re.compile(
        r"\b(atomic_write_qml|create_questionnaire_file|clone_questionnaire_file"
        r"|ensure_sample_questionnaire_files)\b"
    ),
)

#: Files permitted to read QML from a directory, each with the reason it is not
#: a document-store read. Paths are repo-relative.
ALLOWLIST: dict[str, str] = {
    # The loader's own filesystem branch — fixtures and the CLI.
    "shared/modules/askalot_qml/askalot_qml/core/qml_loader.py": (
        "the filesystem branch itself — used by fixtures and the CLI"
    ),
}

#: Only this surface may hold a QML-reading allowlist entry. Anything else must
#: be a non-QML use of the org volume.
_QML_READ_ALLOWED_PREFIXES = ("shared/modules/askalot_qml/askalot_qml/",)

#: Files permitted to WRITE a ``.qml`` path, with the reason. Empty, and that
#: is the point: authored content lands as an attributed version row, and the
#: canonical write touches no filesystem at all. If an entry ever needs to come
#: back here, it needs a reason that survives the question "why is this not a
#: version row?".
WRITE_ALLOWLIST: dict[str, str] = {}

_SCANNED_TREES = ("shared/modules", "services")
#: Directories that are not production source: virtualenvs, build output, tests.
_SKIP_DIR_PARTS = {
    ".venv",
    "node_modules",
    "__pycache__",
    "tests",
    "dist",
    "build",
    "alembic",
}


def _repo_root() -> Path:
    """Walk up to the monorepo root (the directory holding CLAUDE.md + services/)."""
    for candidate in Path(__file__).resolve().parents:
        if (candidate / "services").is_dir() and (candidate / "shared" / "modules").is_dir():
            return candidate
    pytest.skip("monorepo root not reachable from this checkout")


def _production_sources(root: Path) -> list[Path]:
    files: list[Path] = []
    for tree in _SCANNED_TREES:
        for path in (root / tree).rglob("*.py"):
            if _SKIP_DIR_PARTS & set(path.parts):
                continue
            files.append(path)
    return files


@pytest.fixture(scope="module")
def sources() -> list[tuple[str, str]]:
    root = _repo_root()
    return [
        (str(path.relative_to(root)), path.read_text(encoding="utf-8"))
        for path in _production_sources(root)
    ]


@pytest.mark.integration
class TestNoOrgTreeQMLReads:
    def test_scan_actually_covers_the_production_trees(self, sources):
        """A mis-rooted scan must fail, not pass vacuously."""
        scanned = {rel for rel, _ in sources}

        assert "services/tenant/portor/app/mcp_tools/questionnaire_tools.py" in scanned
        assert "shared/modules/askalot_qml/askalot_qml/core/qml_loader.py" in scanned
        assert len(scanned) > 200

    def test_no_unallowlisted_qml_globbing(self, sources):
        offenders = sorted(
            rel for rel, text in sources if _QML_GLOB.search(text) and rel not in ALLOWLIST
        )

        assert offenders == [], (
            "These modules scan a directory for *.qml. QML is canonical in the "
            "document store — read it through askalot_qml.core.qml_source "
            f"(RepositoryQMLSource / load_qml_content): {offenders}"
        )

    def test_no_unallowlisted_organizations_dir_use(self, sources):
        offenders = sorted(
            rel for rel, text in sources if _ORG_DIR_LOADER.search(text) and rel not in ALLOWLIST
        )

        assert offenders == [], (
            "These modules reach into ORGANIZATIONS_DIR. If this is a QML read, "
            "resolve it from the document store instead; if it is a dataset / "
            f"upload / brief path, add it to the allowlist with a reason: {offenders}"
        )

    def test_no_unallowlisted_qml_writes(self, sources):
        """U7: the filesystem is not a QML write target any more."""
        offenders = sorted(
            rel
            for rel, text in sources
            if rel not in WRITE_ALLOWLIST
            and any(pattern.search(text) for pattern in _QML_WRITE_SIGNATURES)
        )

        assert offenders == [], (
            "These modules write QML to the filesystem. Every QML write is a "
            "version append through the repository "
            "(Repository.save_questionnaire_qml / create_questionnaire_document), "
            f"so it carries an author and a provenance (R13): {offenders}"
        )

    def test_write_gate_signatures_match_the_shapes_they_claim(self):
        """The write gate must actually fire on the code it forbids.

        Without this, a typo in one of the regexes would leave that shape
        silently unguarded and every run would pass — a gate that has never
        matched anything proves nothing.
        """
        forbidden_samples = [
            'qml_path.write_text(content, encoding="utf-8")',
            'os.replace(tmp, target_qml.qml)',
            'shutil.move(str(src), str(dst / "x.qml"))',
            'atomic_write_qml(qml_path, content)',
            "create_questionnaire_file(repo, root, pid, name)",
            "clone_questionnaire_file(repo=repo, workspace_root=root)",
            "ensure_sample_questionnaire_files(repo, root, project_id)",
        ]
        for sample in forbidden_samples:
            assert any(pattern.search(sample) for pattern in _QML_WRITE_SIGNATURES), (
                f"No write-gate signature matches {sample!r} — the gate would not "
                "catch this shape if it came back."
            )

        allowed_samples = [
            'summary_path.write_text(body, encoding="utf-8")',
            'repo.save_questionnaire_qml(qid, content, author_type="system", origin="create")',
            "os.replace(tmp, brief_path)",
        ]
        for sample in allowed_samples:
            assert not any(pattern.search(sample) for pattern in _QML_WRITE_SIGNATURES), (
                f"Write gate over-matches {sample!r} — it is not a QML write, and a "
                "gate that flags unrelated code gets allowlisted into uselessness."
            )

    def test_write_allowlist_entries_all_exist(self):
        root = _repo_root()
        missing = sorted(rel for rel in WRITE_ALLOWLIST if not (root / rel).is_file())

        assert missing == [], f"Allowlisted writers that no longer exist — prune them: {missing}"

    def test_allowlist_entries_all_exist(self):
        root = _repo_root()
        missing = sorted(rel for rel in ALLOWLIST if not (root / rel).is_file())

        assert missing == [], f"Allowlisted files that no longer exist — prune them: {missing}"

    def test_allowlist_entries_are_still_needed(self, sources):
        """An entry whose file no longer matches any signature is a live hole.

        The allowlist is checked by path, not by what the file does, so a
        stale entry silently pre-authorises a violation nobody has written yet:
        the day someone adds an org-tree QML read to an already-listed module,
        the gate waves it through. Pruning is therefore not tidiness — it is
        what keeps the remaining entries meaningful.
        """
        by_path = dict(sources)
        unnecessary = sorted(
            rel
            for rel in ALLOWLIST
            if rel in by_path
            and not (_QML_GLOB.search(by_path[rel]) or _ORG_DIR_LOADER.search(by_path[rel]))
        )

        assert unnecessary == [], (
            "Allowlist entries whose file no longer reads the org tree — prune "
            f"them so the list keeps meaning what it says: {unnecessary}"
        )

    def test_write_allowlist_entries_are_still_needed(self, sources):
        """Same rot check for the write side, which is empty today (U11)."""
        by_path = dict(sources)
        unnecessary = sorted(
            rel
            for rel in WRITE_ALLOWLIST
            if rel in by_path
            and not any(pattern.search(by_path[rel]) for pattern in _QML_WRITE_SIGNATURES)
        )

        assert unnecessary == [], f"Stale write-allowlist entries — prune them: {unnecessary}"

    def test_allowlist_entries_carry_a_reason(self):
        unreasoned = sorted(rel for rel, reason in ALLOWLIST.items() if len(reason.strip()) < 10)

        assert unreasoned == [], f"Allowlist entries without a real reason: {unreasoned}"

    def test_only_sanctioned_surfaces_may_read_qml_files(self, sources):
        """An allowlisted *QML* read must be loader-internal."""
        by_path = dict(sources)
        qml_readers = sorted(
            rel for rel in ALLOWLIST if rel in by_path and _QML_GLOB.search(by_path[rel])
        )
        unsanctioned = [
            rel for rel in qml_readers if not rel.startswith(_QML_READ_ALLOWED_PREFIXES)
        ]

        assert unsanctioned == [], (
            "Only the loader itself may scan for "
            f"QML files: {unsanctioned}"
        )
