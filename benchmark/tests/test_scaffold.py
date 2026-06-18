"""Smoke checks for the benchmark environment.

These verify the isolated benchmark project resolves both the validator
(editable path dependency) and the plotting dependency, so later units can rely
on importing them.
"""


def test_validator_importable():
    import askalot_qml  # noqa: F401
    from askalot_qml.core.qml_engine import QMLEngine  # noqa: F401
    from askalot_qml.models.qml_state import QMLState  # noqa: F401


def test_benchmark_package_importable():
    import benchmark

    assert benchmark.__version__
