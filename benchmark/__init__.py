"""QML validator benchmark harness.

A scaling study of the QML validator: generate synthetic questionnaires across
four axes (item count, precondition count, postcondition count, dependency
depth), validate each in-process while measuring construction time, isolated
Z3-solve time, and peak memory, then render one PNG figure per axis.

Lives in a top-level folder outside ``askalot_qml`` because the release-mirror
sync regenerates the root ``pyproject.toml`` and replaces the root ``tests/``
tree on every ``qml-v*`` tag. The validator is imported and called as-is.
"""

__all__ = ["__version__"]
__version__ = "0.1.0"
