"""DB-canonical QML content resolution (plan 2026-07-21-001, U5).

QML content lives in the unified document store (``documents`` +
``document_versions``, see ``askalot_common.repository.mixins.document``). This
module is the one place that turns a *questionnaire* — or a canonical
``qml_name`` relative path — into the YAML text every downstream consumer
parses, so no service re-derives the document lookup.

Two resolution modes, and the difference is the fielding guarantee (R11/KTD6):

Head read
    :func:`load_qml_content` returns the document's current head. This is the
    authoring/inspection read — MCP validate/inspect/get, the item-count and
    external-item helpers, dataset extraction schema build.

Pinned read
    :func:`load_fielded_qml_content` resolves the content a *survey* must be
    served: the version its campaign pinned at publish time
    (``campaigns.qml_version_id``). A survey in flight keeps seeing the exact
    document it was fielded against even after the questionnaire's head
    advances. Only a campaign-less (ad-hoc preview) survey falls back to head,
    and that fallback is explicit — a campaign that exists but carries no pin
    is a pre-cutover row, not a licence to serve moving content silently, so it
    reads head and says so in the log.

:class:`RepositoryQMLSource` adapts either mode to :class:`~askalot_qml.core.qml_loader.QMLLoader`'s
content-source seam, so the loader's parse/validate pipeline is reached by
name exactly as it was when names meant files.
"""

from __future__ import annotations

import logging
import re
from typing import Any, Protocol, runtime_checkable

from askalot_common.repository.entities import derive_questionnaire_qml_rel_path

#: Canonical relative path of a questionnaire's QML, as
#: ``askalot_common.repository.entities.derive_questionnaire_qml_rel_path``
#: renders it. The document store keys a ``qml`` document on
#: ``(project_id, kind="qml", key=<questionnaire_id>)``, so this pattern is the
#: bridge between a caller holding a name and the document identity.
CANONICAL_QML_REL_PATH = re.compile(
    r"^projects/(?P<project_id>[^/]+)/questionnaires/(?P<questionnaire_id>[^/]+)\.qml$"
)

logger = logging.getLogger(__name__)


class QMLDocumentMissingError(FileNotFoundError):
    """No document (or no version) backs the requested questionnaire.

    Subclasses ``FileNotFoundError`` because every caller of the pre-document
    read path already distinguished "content is gone" from "content is broken"
    on that type — a stranded questionnaire row stays a 404/409-shaped
    data-integrity signal rather than becoming an opaque 500.
    """


@runtime_checkable
class QMLContentSource(Protocol):
    """What :class:`QMLLoader` needs to resolve a ``qml_name`` without a filesystem."""

    def read(self, qml_name: str) -> str:
        """Return the QML text for ``qml_name``.

        Raises:
            QMLDocumentMissingError: nothing backs that name.
        """
        ...

    def list_names(self) -> list[str]:
        """Every ``qml_name`` this source can resolve, sorted."""
        ...


def canonical_qml_rel_path(project_id: str, questionnaire_id: str) -> str:
    """The ``qml_name`` a questionnaire's document is addressed by.

    Delegates to ``askalot_common``'s canonical renderer so the format has one
    source of truth — the ``CANONICAL_QML_REL_PATH`` regex above parses what
    that function builds, and a future layout change updates both by touching
    only the renderer.
    """
    return derive_questionnaire_qml_rel_path(project_id, questionnaire_id)


def load_qml_content(repository: Any, questionnaire: Any, *, version_id: str | None = None) -> str:
    """Resolve a questionnaire's QML text — head, or an explicit version.

    Args:
        repository: An ``askalot_common`` ``Repository`` (``DocumentMixin``).
        questionnaire: ``DTO_Questionnaire`` carrying ``document_id``.
        version_id: When given, that exact ``document_versions`` row is read
            instead of head. A version belonging to another document raises —
            it is a caller bug, never a miss.

    Raises:
        QMLDocumentMissingError: the questionnaire has no document link, the
            document is gone, or it has no version yet.
    """
    document_id = getattr(questionnaire, "document_id", None)
    if not document_id:
        raise QMLDocumentMissingError(
            f"Questionnaire {getattr(questionnaire, 'id', '<unknown>')!r} has no QML document — "
            "the tenant's content import has not run for it."
        )

    version = repository.get_document_content(document_id, version_id=version_id)
    if version is None:
        raise QMLDocumentMissingError(
            f"QML document {document_id!r} for questionnaire "
            f"{getattr(questionnaire, 'id', '<unknown>')!r} has no "
            f"{'version ' + repr(version_id) if version_id else 'content'}."
        )
    content = version.content
    # Refuse a non-string before any consumer hands it to PyYAML, which
    # duck-types an attribute-answering object (a test double, a lazy proxy)
    # as a stream and reads it unbounded until memory is exhausted. This is
    # the one chokepoint every document-store QML read funnels through, so
    # the guard here covers fielding, item-count, external-item, and MCP
    # reads alike (see docs/solutions/logic-errors/
    # pyyaml-duck-types-a-mock-as-a-stream-and-allocates-until-oom.md).
    if not isinstance(content, str):
        raise TypeError(
            f"QML document {document_id!r} resolved to {type(content).__name__}, "
            "not QML text — refusing before PyYAML reads it as a stream."
        )
    return content


def load_fielded_qml_content(repository: Any, survey: Any, questionnaire: Any) -> str:
    """Resolve the QML text a survey must be served (F4 — the fielding pin).

    A campaign pins ``qml_version_id`` when its questionnaire is published;
    every survey fielded under that campaign reads that version for its whole
    life, so a later save/publish on the questionnaire cannot change the
    instrument mid-interview.

    Head is read only when there is no pin to honour:

    - the survey has no campaign (ad-hoc preview), or
    - the campaign row carries no ``qml_version_id`` (pre-cutover campaign) —
      logged at warning level, because a live campaign without a pin is a
      migration gap, not a design choice.
    """
    campaign_id = getattr(survey, "campaign_id", None)
    if not campaign_id:
        return load_qml_content(repository, questionnaire)

    campaign = repository.get_campaign(campaign_id)
    pinned_version_id = getattr(campaign, "qml_version_id", None) if campaign else None
    if not pinned_version_id:
        logger.warning(
            "Survey %s: campaign %s has no pinned QML version — serving document head",
            getattr(survey, "id", "<unknown>"),
            campaign_id,
        )
        return load_qml_content(repository, questionnaire)

    return load_qml_content(repository, questionnaire, version_id=pinned_version_id)


class RepositoryQMLSource:
    """Resolve ``qml_name`` relative paths against the document store.

    Adapts the document store to the loader seam for the callers that still
    speak in names (MCP tools, the org-wide listing). A name that is not a
    canonical questionnaire path resolves to nothing — org-root and ``shared/``
    tree layouts have no document identity, so they fail loud instead of
    silently reading a file.
    """

    def __init__(self, repository: Any) -> None:
        self.repository = repository

    def _questionnaire_for(self, qml_name: str) -> Any:
        match = CANONICAL_QML_REL_PATH.match(qml_name)
        if not match:
            raise QMLDocumentMissingError(
                f"QML name {qml_name!r} is not a canonical questionnaire path "
                f"(projects/<project_id>/questionnaires/<questionnaire_id>.qml) — "
                "only questionnaire documents are addressable."
            )
        questionnaire = self.repository.get_questionnaire(match.group("questionnaire_id"))
        if questionnaire is None:
            raise QMLDocumentMissingError(
                f"No questionnaire {match.group('questionnaire_id')!r} for QML name {qml_name!r}."
            )
        return questionnaire

    def read(self, qml_name: str) -> str:
        """The head content of the questionnaire ``qml_name`` addresses."""
        return load_qml_content(self.repository, self._questionnaire_for(qml_name))

    def list_names(self) -> list[str]:
        """Canonical names of every live QML document in the organization."""
        documents = self.repository.list_documents(kind="qml")
        return sorted(canonical_qml_rel_path(d.project_id, d.key) for d in documents)
