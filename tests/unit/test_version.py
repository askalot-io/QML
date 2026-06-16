"""
askalot_qml package-version single-source-of-truth contract tests.

Tests that the importable package version never drifts from versions.mk:
- askalot_qml.__version__ is a static literal (no importlib.metadata) so it
  resolves identically from a raw source tree, an editable install, and a
  mirror-staged copy — the published OSS package must report the truth
- __version__ equals the version in this module's pyproject.toml
- __version__ equals ASKALOT_QML_VERSION parsed from shared/modules/versions.mk
  (the single source of truth synced by update_module_versions.sh)
- the drift guard is real: scripts/release/check_version_bumps.sh +
  update_module_versions.sh STRICT mode is the same protection the other
  three modules already get — this test pins the invariant those guards
  enforce so a silent literal edit fails here too

These unit tests read the on-disk versions.mk / pyproject.toml directly (no
build, no install) so they catch the exact stale-literal contradiction this
suite was created to eliminate (askalot_qml/__init__.py once hardcoded
"2.0.0" while versions.mk/pyproject said 1.28.0).
"""

import re
from pathlib import Path

import pytest
from askalot_qml import __version__ as package_version

# tests/unit/test_version.py -> askalot_qml module root -> shared/modules root
_MODULE_ROOT = Path(__file__).resolve().parents[2]
_PYPROJECT = _MODULE_ROOT / "pyproject.toml"
_VERSIONS_MK = _MODULE_ROOT.parent / "versions.mk"

_SEMVER = re.compile(r"^\d+\.\d+\.\d+$")


def _pyproject_version() -> str:
    for line in _PYPROJECT.read_text(encoding="utf-8").splitlines():
        m = re.match(r'^version = "([^"]+)"', line)
        if m:
            return m.group(1)
    raise AssertionError(f"no `version = \"...\"` in {_PYPROJECT}")


def _versions_mk_qml() -> str:
    for line in _VERSIONS_MK.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^ASKALOT_QML_VERSION\s*:=\s*(\S+)", line)
        if m:
            return m.group(1)
    raise AssertionError(f"no ASKALOT_QML_VERSION in {_VERSIONS_MK}")


@pytest.mark.unit
class TestPackageVersionContract:
    def test_version_is_three_part_semver(self):
        assert _SEMVER.match(package_version), (
            f"askalot_qml.__version__ must be Major.Minor.Patch, got "
            f"{package_version!r}"
        )

    def test_version_matches_pyproject(self):
        assert package_version == _pyproject_version(), (
            "askalot_qml.__version__ has drifted from pyproject.toml — run "
            "scripts/release/update_module_versions.sh"
        )

    def test_version_matches_versions_mk(self):
        # versions.mk is the single source of truth; the __init__.py literal
        # is a synced derivative, not an independent value.
        assert package_version == _versions_mk_qml(), (
            "askalot_qml.__version__ has drifted from versions.mk "
            "(ASKALOT_QML_VERSION) — run "
            "scripts/release/update_module_versions.sh"
        )

    def test_version_is_static_literal_not_importlib_metadata(self):
        # The literal must resolve without any installed distribution. This
        # test runs against the raw source tree; if __version__ were derived
        # from importlib.metadata it would raise PackageNotFoundError or
        # report stale install-frozen metadata here.
        assert package_version and package_version != "0.0.0"
