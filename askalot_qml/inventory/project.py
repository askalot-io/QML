"""The instrument facts of a whole project: every inventoried questionnaire, joined with its QML.

The one module of this package that reads stored rows. The research paper's
Instrument Design chapter, and an agent reading that chapter, show what each
questionnaire of the project asks and how each KPI is collected. Both are
computed here from the stored inventories every time they are read, and
nothing of them is written back.

- ``project_instrument_tables`` answers one entry per live questionnaire of the
  project that has an inventory, in the order the project lists its
  questionnaires: ``{"questionnaire_id", "name", "view_facts", "links"}``.
  ``view_facts`` is ``view.inventory_view_facts`` computed with the KPI tokens
  the project's paper numbers; ``links`` is ``coverage.covering_links`` with
  the questionnaire's id added to each link.
- ``project_instrument_design`` answers what a reader of the chapter is shown:
  ``{"kpi_collection", "tables"}``, where ``tables`` is the list above and
  ``kpi_collection`` maps each KPI the paper numbers, in the paper's order, to
  how the links of all questionnaires collect it
  (``coverage.collection_modes``). ``None`` when no questionnaire of the
  project has a readable inventory, so a caller draws nothing.

Both are two steps, and a caller on an event loop takes them apart:
``gather_instrument_sources`` does every repository read (on the caller's
thread, where the repository's session lives), and
``instrument_tables_from_sources`` / ``instrument_design_from_sources`` are pure
over what it gathered (the QML parse and the join with the inventory), so they
can run on a worker thread.

Decisions and constraints:

- **An unreadable questionnaire is left out, never an error.** A head QML that
  does not load, an inventory that does not parse, a join that raises, or a
  questionnaire deleted between two reads is logged at WARNING by id and
  skipped: the chapter around the table is the paper's own text and must still
  be shown, and one questionnaire must not cost the others their table. The
  log names the questionnaire and the kind of failure, never its content.
- **A project-level read that fails raises.** The inventory heads, the
  questionnaire list, the QML heads and the paper's KPI tokens are read once
  for the whole answer; without them there is nothing true to show.
- **Loading is cached per process.** Parsing a large QML on every render of
  the paper would cost more than the page. The facts of one questionnaire are
  a pure function of three immutable things (the QML version, the inventory
  version, the paper's KPI tokens), so they are kept in a small
  least-recently-used map under exactly that key. A new version of either
  document is a new key; no entry is ever invalidated, and no state is shared
  between worker processes because none is needed. The questionnaire's name is
  not part of the cached facts, so a rename shows at once.
- **The cheap reads come first.** The inventory heads and the QML heads are
  read without content; a QML body is fetched only on a cache miss, pinned to
  the head version the key names.
- **Cached facts are shared.** A caller reads what this module answers and
  never mutates it.
"""

from __future__ import annotations

import logging
import threading
from collections import OrderedDict
from typing import Any

from askalot_common.repository.mixins.qml_document import QuestionnaireNotFoundError
from askalot_common.sampling.apply_plan import paper_kpi_tokens

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_source import load_qml_content
from askalot_qml.inventory.coverage import collection_modes, covering_links
from askalot_qml.inventory.model import parse_inventory
from askalot_qml.inventory.view import inventory_view_facts

logger = logging.getLogger(__name__)

#: How many questionnaires' facts one process keeps. A project holds a handful
#: of questionnaires, so this covers the projects being read at one time.
_CACHE_SIZE = 64

_CacheKey = tuple[str, str, tuple[str, ...]]
_cache: OrderedDict[_CacheKey, dict[str, Any]] = OrderedDict()
_cache_lock = threading.Lock()


def project_instrument_tables(repo: Any, project_id: str) -> list[dict[str, Any]]:
    """One entry per live, inventoried questionnaire of the project, in the project's order."""
    return instrument_tables_from_sources(gather_instrument_sources(repo, project_id))


def project_instrument_design(repo: Any, project_id: str) -> dict[str, Any] | None:
    """The KPI collection modes and the instrument tables of the project; ``None`` without any table."""
    return instrument_design_from_sources(gather_instrument_sources(repo, project_id))


def gather_instrument_sources(repo: Any, project_id: str) -> dict[str, Any]:
    """Everything the instrument facts are computed from, read from the repository.

    ``{"tokens": the paper's KPI tokens, "questionnaires": [...]}``, one entry
    per live, inventoried questionnaire in the project's order. An entry holds
    ``questionnaire_id``, ``name`` and either ``facts`` (already cached for its
    versions) or the texts to compute them from: ``qml``, ``inventory`` and the
    version ids they were read at. The paper is not read without an inventory.
    A questionnaire whose own content cannot be read is left out.
    """
    inventory_heads = repo.questionnaire_inventory_heads(project_id)
    if not inventory_heads:
        return {"tokens": (), "questionnaires": []}
    tokens = tuple(paper_kpi_tokens(repo, project_id))
    questionnaires, _total = repo.list_questionnaires(project_id=project_id)
    inventoried = [q for q in questionnaires if str(q.id) in inventory_heads]
    qml_heads = repo.document_heads([str(q.document_id) for q in inventoried if q.document_id])

    sources: list[dict[str, Any]] = []
    for questionnaire in inventoried:
        questionnaire_id = str(questionnaire.id)
        qml_head = qml_heads.get(str(questionnaire.document_id))
        if qml_head is None:
            logger.warning(
                "instrument tables: questionnaire %s has no QML head, left out", questionnaire_id
            )
            continue
        source: dict[str, Any] = {"questionnaire_id": questionnaire_id, "name": questionnaire.name}
        qml_version_id = qml_head.version_id
        cached = _cached((qml_version_id, inventory_heads[questionnaire_id], tokens))
        if cached is not None:
            sources.append({**source, "facts": cached})
            continue
        try:
            qml = load_qml_content(repo, questionnaire, version_id=qml_version_id)
        except Exception as exc:
            logger.warning(
                "instrument tables: QML of questionnaire %s (version %s) cannot be read, "
                "left out (%s)",
                questionnaire_id,
                qml_version_id,
                type(exc).__name__,
            )
            continue
        try:
            stored = repo.get_questionnaire_inventory(questionnaire_id)
        except QuestionnaireNotFoundError:
            logger.warning(
                "instrument tables: questionnaire %s is gone, left out", questionnaire_id
            )
            continue
        if stored is None:
            continue
        # The inventory may have moved since its head was listed: the facts are
        # stored under the version this read returned.
        sources.append(
            {
                **source,
                "qml": qml,
                "qml_version_id": qml_version_id,
                "inventory": stored.content,
                "inventory_version_id": str(stored.version_id),
            }
        )
    return {"tokens": tokens, "questionnaires": sources}


def instrument_tables_from_sources(sources: dict[str, Any]) -> list[dict[str, Any]]:
    """The instrument tables of gathered sources. Pure: reads no repository."""
    tokens: tuple[str, ...] = sources["tokens"]
    tables: list[dict[str, Any]] = []
    for source in sources["questionnaires"]:
        facts = source.get("facts") or _questionnaire_facts(source, tokens)
        if facts is None:
            continue
        questionnaire_id = source["questionnaire_id"]
        tables.append(
            {
                "questionnaire_id": questionnaire_id,
                "name": source["name"],
                "view_facts": facts["view_facts"],
                "links": [
                    {**link, "questionnaire_id": questionnaire_id} for link in facts["links"]
                ],
            }
        )
    return tables


def instrument_design_from_sources(sources: dict[str, Any]) -> dict[str, Any] | None:
    """What ``project_instrument_design`` answers, from gathered sources. Pure."""
    tables = instrument_tables_from_sources(sources)
    if not tables:
        return None
    links = [link for table in tables for link in table["links"]]
    return {"kpi_collection": collection_modes(links, sources["tokens"]), "tables": tables}


def _questionnaire_facts(source: dict[str, Any], tokens: tuple[str, ...]) -> dict[str, Any] | None:
    """The view facts and covering links of one questionnaire, computed and cached.

    ``None`` when its QML does not load, its inventory does not parse or the
    join of the two raises: that questionnaire is left out and the failure is
    logged without any of its content.
    """
    try:
        qml = QMLLoader(logger=logger).load_from_string(source["qml"])
        inventory = parse_inventory(source["inventory"])
        facts = {
            # The view states coverage only against KPIs the paper numbers.
            "view_facts": inventory_view_facts(qml, inventory, kpi_tokens=list(tokens) or None),
            "links": covering_links(qml, inventory),
        }
    except Exception as exc:
        logger.warning(
            "instrument tables: questionnaire %s (QML version %s, inventory version %s) "
            "cannot be joined with its inventory, left out (%s)",
            source["questionnaire_id"],
            source["qml_version_id"],
            source["inventory_version_id"],
            type(exc).__name__,
        )
        return None
    _store((source["qml_version_id"], source["inventory_version_id"], tokens), facts)
    return facts


def _cached(key: _CacheKey) -> dict[str, Any] | None:
    with _cache_lock:
        facts = _cache.get(key)
        if facts is not None:
            _cache.move_to_end(key)
        return facts


def _store(key: _CacheKey, facts: dict[str, Any]) -> None:
    with _cache_lock:
        _cache[key] = facts
        _cache.move_to_end(key)
        while len(_cache) > _CACHE_SIZE:
            _cache.popitem(last=False)
