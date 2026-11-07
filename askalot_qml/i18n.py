"""askalot_qml's translation catalog, registered when the package is imported.

The flow API answers the respondent's page with a few fixed sentences (survey
completed, cannot navigate, the refusals its modal shows). Those live in this
package's own catalog (``translations/<locale>/LC_MESSAGES/messages.po``), so a
message marked here is owned here and nowhere else. Importing this module is
what adds the catalog to ``askalot_common.i18n``'s lookup, and the package's
``__init__`` does it, so any ``import askalot_qml.<x>`` registers it.
"""

from pathlib import Path

from askalot_common.i18n import register_catalog

register_catalog("askalot_qml", Path(__file__).resolve().parent / "translations")
