
                ifndef _METADATA_MAP_DEBUG_ITEMS_
                define _METADATA_MAP_DEBUG_ITEMS_
; -----------------------------------------
; формирование начального предмета в экипировке
; In:
;   BaseItem?    - индекс базового описания предмета
;   Quality?     - качество предмета ITEM_QUALITY_
;   Flags?       - флаги экземпляра предмета ITEM_FLAG_
;   CharacterID? - индекс персонажа
;   Slot?        - индекс слота в FCharacterEquipment
; -----------------------------------------
MAP_ITEM_EQUIP  macro BaseItem?, Quality?, Flags?, CharacterID?, Slot?
                FMapItem {
                    { BaseItem?, Quality?, Flags?, #00 },
                    {
                        ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM,
                        CharacterID?,
                        { Slot?, #00 }
                    }
                }
                endm
; -----------------------------------------
; формирование начального предмета в сетке
; In:
;   BaseItem?  - индекс базового описания предмета
;   Quality?   - качество предмета ITEM_QUALITY_
;   Flags?     - флаги экземпляра предмета ITEM_FLAG_
;   Container? - индекс контейнера
;   X?         - столбец сетки в ячейках
;   Y?         - строка сетки в ячейках
; -----------------------------------------
MAP_ITEM_GRID   macro BaseItem?, Quality?, Flags?, Container?, X?, Y?
                FMapItem {
                    { BaseItem?, Quality?, Flags?, #00 },
                    { #00, Container?, { X?, Y? } }
                }
                endm
; -----------------------------------------
;   начальные предметы карты
; -----------------------------------------
                DB Items.Num                                                    ; количество предметов в блоке

                ; "Волчий клык", магический амулет, индекс базового предмета 7
                MAP_ITEM_EQUIP #07, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Amulet.ID

                ; "Кремень духа", редкий амулет, индекс базового предмета 8
                MAP_ITEM_GRID #08, ITEM_QUALITY_RARE, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, #02, #00

                ; "Оберег ратоборца", уникальный амулет, индекс базового предмета 11
                MAP_ITEM_GRID #0B, ITEM_QUALITY_UNIQUE, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, #04, #00

                ; "Броня", обычный предмет, индекс базового предмета 12
                MAP_ITEM_EQUIP #0C, ITEM_QUALITY_NORMAL, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Breast.ID

                ; "Шелом стража", обычный предмет, индекс базового предмета 13
                MAP_ITEM_EQUIP #0D, ITEM_QUALITY_NORMAL, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Head.ID

                ; "Наплечи дружинника", предмет высшего качества, индекс базового предмета 15
                MAP_ITEM_EQUIP #0F, ITEM_QUALITY_NORMAL, ITEM_FLAG_SUPERIOR, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.ShoulderPad.ID

                ; "Кушак крепости", магический предмет, индекс базового предмета 3
                MAP_ITEM_EQUIP #03, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Belt.ID

                ; "Щит ратника", редкий предмет, индекс базового предмета 14
                MAP_ITEM_EQUIP #0E, ITEM_QUALITY_RARE, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.LeftHand.ID

                ; "Меч дружинника", магический предмет, индекс базового предмета 6
                MAP_ITEM_EQUIP #06, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.RightHand.ID

                ; "Перстень ведуна", магический предмет, индекс базового предмета 1
                MAP_ITEM_EQUIP #01, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.LeftRing.ID

                ; "Сапоги странника", магический предмет, индекс базового предмета 4
                MAP_ITEM_EQUIP #04, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Boot.ID

                ; "Секира ратника", предмет высшего качества, индекс базового предмета 0
                MAP_ITEM_GRID #00, ITEM_QUALITY_NORMAL, ITEM_FLAG_SUPERIOR, \
                    PLAYER_CHARACTER_ID_MAIN, #06, #00

                ; "Маска", обычный предмет, индекс базового предмета 5
                MAP_ITEM_GRID #05, ITEM_QUALITY_NORMAL, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, #00, #02

                ; "Оберег странника", магический амулет, индекс базового предмета 9
                MAP_ITEM_GRID #09, ITEM_QUALITY_MAGIC, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, #04, #02

                ; "Купеческая мошна", редкий амулет, индекс базового предмета 10
                MAP_ITEM_GRID #0A, ITEM_QUALITY_RARE, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, #05, #02

                ; "Перстень прозрения", уникальное кольцо, индекс базового предмета 2
                MAP_ITEM_EQUIP #02, ITEM_QUALITY_UNIQUE, ITEM_FLAG_NONE, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.RightRing.ID
Items.Num       EQU ($-Items-1) / FMapItem

                endif ; ~_METADATA_MAP_DEBUG_ITEMS_
