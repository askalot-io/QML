"""
QML schema version contract tests.

Tests the decoupled Major.Minor.Patch schema-version signal:
- the bundled qml-schema.json carries a top-level `version`
- `version` is valid three-part semver
- `QML_SCHEMA_VERSION` is read from (never hardcoded apart from) the schema
  file — the single-source-of-truth / no-drift guarantee
- the current contract version is 2.1.0 (the 2.0.0 breaking collapse of block
  kinds to Group + Roster, plus the 2.1.0 backward-compatible addition of the
  optional Roster `subjectFrom` key)
- the schema version is independent of the askalot_qml package version

These unit tests pin the contract so a schema change cannot silently ship
without a deliberate version move, and the in-code constant can never drift
from the schema file.
"""

import json
import re

import pytest
from askalot_qml.schema import QML_SCHEMA_VERSION, SCHEMA_PATH

_SEMVER = re.compile(r"^\d+\.\d+\.\d+$")


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

    def test_current_contract_version_is_2_1_0(self):
        # 2.0.0 was the first breaking (MAJOR) change: block kinds collapse to
        # Group + Roster (Sequence/Sample removed, is_random dropped, kind made
        # optional). 2.1.0 is a backward-compatible (MINOR) addition: the
        # optional Roster `subjectFrom` key (respondent-named iteration subject);
        # every 2.0.0 document stays valid.
        assert QML_SCHEMA_VERSION == "2.1.0"

    def test_schema_version_decoupled_from_package_version(self):
        # Decoupled by policy: a code-only release moves the package version
        # but not the schema. They are not required to be equal and generally
        # are not (the package has its own independent release cadence).
        from askalot_qml import __version__ as package_version

        assert QML_SCHEMA_VERSION != package_version, (
            "schema and package versions are independent; this test documents "
            "the decoupling — it must not assert equality between them"
        )
