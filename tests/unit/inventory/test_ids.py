"""
The source-id to QML item-id mapper an imported questionnaire's inventory records.

Tests askalot_qml.inventory.ids.map_source_ids:
- A printed question number becomes an item id (`1` -> `Q1`, `Q1a.` -> `Q1a`)
- Source ids that would map to one id, or to ids equal in lower case, get distinct ids
- A source id that is a sandbox name or a reserved id (`len`, `codeInit`, `if`) maps to a safe id
- A source id with no usable character, or with non-ASCII letters, still maps to a valid id
- Every output passes the loader's item-id rule, and a document using them loads
- The same source ids map to the same item ids on a second call

These unit tests judge the mapper's output with the loader's own rule and the real
QMLLoader, so a mapped id is proven to be one the loader accepts rather than one a
copy of the rule accepts.
"""

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader, is_readable_item_id
from askalot_qml.inventory import map_source_ids

#: Source ids as printed questionnaires spell them, including the awkward ones.
AWKWARD_SOURCE_IDS = [
    "1",
    "Q1a.",
    "1a",
    "1A",
    "1a.",
    "len",
    "codeInit",
    "__init__",
    "if",
    "math",
    "2.3 (b)",
    "§ 4",
    "...",
    "",
    "Kérdés 5",
    "ﬁ6",
    "Q1a_2",
]


def _accepted_by_loader(item_id: str) -> bool:
    return item_id not in QMLLoader.RESERVED_ITEM_IDS and is_readable_item_id(item_id)


class TestMapSourceIds:
    def test_a_question_number_becomes_an_item_id(self):
        assert map_source_ids(["1", "Q1a."]) == ["Q1", "Q1a"]

    def test_ids_kept_apart_in_lower_case_stay_apart(self):
        mapped = map_source_ids(["1a", "1A", "1a."])

        assert mapped[0] == "Q1a"
        assert len({item_id.lower() for item_id in mapped}) == 3

    def test_a_sandbox_or_reserved_name_maps_to_a_safe_id(self):
        mapped = map_source_ids(["len", "codeInit", "if", "math"])

        assert mapped == ["Q_len", "Q_codeInit", "Q_if", "Q_math"]

    def test_a_suffixed_id_and_a_source_spelling_it_stay_apart(self):
        mapped = map_source_ids(["1a", "1a.", "Q1a_2"])

        assert len({item_id.lower() for item_id in mapped}) == 3

    def test_every_output_passes_the_loader_rule_and_loads(self):
        mapped = map_source_ids(AWKWARD_SOURCE_IDS)

        assert len(mapped) == len(AWKWARD_SOURCE_IDS)
        assert len({item_id.lower() for item_id in mapped}) == len(mapped)
        for source_id, item_id in zip(AWKWARD_SOURCE_IDS, mapped, strict=True):
            assert _accepted_by_loader(item_id), (source_id, item_id)
        document = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Mapped ids",
                "blocks": [
                    {
                        "id": "b",
                        "title": "B",
                        "items": [
                            {"id": item_id, "kind": "Comment", "title": "T"} for item_id in mapped
                        ],
                    }
                ],
            },
        }
        loaded = QMLLoader().load_from_string(yaml.safe_dump(document, allow_unicode=True))
        assert [item["id"] for item in loaded["items"]] == mapped

    def test_the_same_source_ids_map_to_the_same_ids_again(self):
        assert map_source_ids(AWKWARD_SOURCE_IDS) == map_source_ids(list(AWKWARD_SOURCE_IDS))

    @pytest.mark.parametrize("source_id", ["", "...", "§"])
    def test_a_source_id_with_no_usable_character_still_maps(self, source_id):
        (item_id,) = map_source_ids([source_id])

        assert _accepted_by_loader(item_id)
