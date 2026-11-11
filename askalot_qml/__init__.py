"""
Askalot QML Module

Z3-driven QML processing and analysis engine for the Askalot platform.
Import from the specific submodule you need:

    from askalot_qml.core import QMLLoader, FlowProcessor, ValidationProcessor
    from askalot_qml.z3 import StaticBuilder
    from askalot_qml.models import ItemProxy, QMLState
    from askalot_qml.api import create_validation_blueprint, create_flow_blueprint
    from askalot_qml.schema import SCHEMA_PATH
"""

__version__ = "1.119.0"

# Registers this package's translation catalog on any askalot_qml import, so a
# service never has to remember to: a word askalot_qml owns reaches a page
# through some askalot_qml import, which therefore loaded its translations.
from . import i18n  # noqa: E402, F401
