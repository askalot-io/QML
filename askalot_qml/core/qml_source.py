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
from dataclasses import dataclass
from typing import Any, Literal, Protocol, runtime_checkable

from askalot_common.repository.entities import derive_questionnaire_qml_rel_path
from askalot_common.repository.mixins.document import HeadContentProbe

#: The canonical form of a questionnaire address, as
#: ``askalot_common.repository.entities.derive_questionnaire_qml_rel_path``
#: renders it. Private: :func:`parse_qml_address` is the only reader.
_CANONICAL_ADDRESS = re.compile(
    r"^projects/(?P<project_id>[^/]+)/questionnaires/(?P<questionnaire_id>[^/]+)\.qml$"
)

_QML_SUFFIX = ".qml"

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class QMLAddress:
    """The ids a ``qml_name`` carries, and which of the two forms it was written in.

    ``form`` is ``"canonical"`` for ``projects/<project_id>/questionnaires/<questionnaire_id>.qml``
    and ``"bare"`` for ``<questionnaire_id>.qml``, which names no project. The
    ids are the address's own text: nothing here says they are UUIDs or that a
    questionnaire exists under them.
    """

    project_id: str | None
    questionnaire_id: str
    form: Literal["canonical", "bare"]


def parse_qml_address(qml_name: str) -> QMLAddress | None:
    """Turn a ``qml_name`` into its ids, or ``None`` when it addresses no questionnaire.

    The one parser of the questionnaire address grammar. The document store
    keys a ``qml`` document on ``(project_id, kind="qml", key=<questionnaire_id>)``,
    so this is the bridge between a caller holding a name and the document
    identity. Slashes around the name are ignored and the ``.qml`` suffix is
    required. Any other layout (an org-root draft path, ``shared/foo.qml``)
    has no document identity and yields ``None``.

    Which forms a caller serves is the caller's policy, read from ``form``:
    reads take the canonical form only, because the reach gate checks canonical
    names; the write resolver and the approval diff take the bare form too.
    """
    name = qml_name.strip("/")
    canonical = _CANONICAL_ADDRESS.match(name)
    if canonical:
        return QMLAddress(
            project_id=canonical.group("project_id"),
            questionnaire_id=canonical.group("questionnaire_id"),
            form="canonical",
        )
    if "/" not in name and name.endswith(_QML_SUFFIX) and len(name) > len(_QML_SUFFIX):
        return QMLAddress(
            project_id=None, questionnaire_id=name[: -len(_QML_SUFFIX)], form="bare"
        )
    return None


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

    Delegates to ``askalot_common``'s canonical renderer; :func:`parse_qml_address`
    reads back what that function builds.
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

    - the walk is a **preview**, which belongs to no campaign and so has no pin
      to read (every survey does — ``ck_surveys_campaign_present``), or
    - the campaign row carries no ``qml_version_id`` — logged at warning level,
      because a live campaign without a pin means its questionnaire was never
      published through the fielding door, which is a gap rather than a design
      choice.
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
        address = parse_qml_address(qml_name)
        if address is None or address.form != "canonical":
            raise QMLDocumentMissingError(
                f"QML name {qml_name!r} is not a canonical questionnaire path "
                f"(projects/<project_id>/questionnaires/<questionnaire_id>.qml) — "
                "only questionnaire documents are addressable."
            )
        questionnaire = self.repository.get_questionnaire(address.questionnaire_id)
        if questionnaire is None:
            raise QMLDocumentMissingError(
                f"No questionnaire {address.questionnaire_id!r} for QML name {qml_name!r}."
            )
        return questionnaire

    def read(self, qml_name: str) -> str:
        """The head content of the questionnaire ``qml_name`` addresses."""
        return load_qml_content(self.repository, self._questionnaire_for(qml_name))

    def read_within(self, qml_name: str, max_bytes: int) -> HeadContentProbe:
        """The head's version id, number and size — and its content only when it fits (#213).

        For a caller choosing between inlining the QML and handing back a
        reference to it: Portor's ``get_qml_content`` picks between the body and
        a signed download URL on a 32 KB threshold. Reading the body to measure
        it defeats the threshold for exactly the large documents it protects,
        but measuring and reading as two calls is worse still — it doubles the
        round trips on the common under-threshold path, and lets a concurrent
        save leave the size describing one version and the body another.

        One repository read answers all of it, so the returned size and the
        returned version id always describe the returned content, and an
        oversized body is never transferred. ``content`` is ``None`` exactly
        when ``size_bytes > max_bytes``.

        Raises ``QMLDocumentMissingError`` on the same misses :meth:`read`
        does — a length of "no document" is not zero.
        """
        questionnaire = self._questionnaire_for(qml_name)
        document_id = getattr(questionnaire, "document_id", None)
        if not document_id:
            raise QMLDocumentMissingError(
                f"Questionnaire {getattr(questionnaire, 'id', '<unknown>')!r} has no QML document — "
                "the tenant's content import has not run for it."
            )
        probe = self.repository.head_content_within(str(document_id), max_bytes=max_bytes)
        if probe is None:
            raise QMLDocumentMissingError(
                f"QML document {document_id!r} for QML name {qml_name!r} has no content."
            )
        # Same PyYAML-stream guard as `load_qml_content`: this is a second
        # document-store QML read path, so it needs the same chokepoint.
        if probe.content is not None and not isinstance(probe.content, str):
            raise TypeError(
                f"QML document {document_id!r} resolved to {type(probe.content).__name__}, "
                "not QML text — refusing before PyYAML reads it as a stream."
            )
        return probe

    def list_names(self) -> list[str]:
        """Canonical names of every live QML document in the organization."""
        documents = self.repository.list_documents(kind="qml")
        return sorted(canonical_qml_rel_path(d.project_id, d.key) for d in documents)
